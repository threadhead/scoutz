require 'spec_helper'

describe EmailMessage do
  before(:all) do
    adult_2units_2scout_3subunits
    @adult2 = FactoryGirl.create(:adult, email: nil)
    @adult2.units << @unit1 # add adult with no email
  end

  it { should belong_to(:sender) }
  it { should belong_to(:unit) }
  it { should have_many(:email_attachments) }
  # it { should have_and_belong_to_many(:users) }
  # it { should have_and_belong_to_many(:events) }

  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:subject) }

  describe 'validations' do
    before { @email_message = FactoryGirl.build(:email_message) }

    it 'should be valid' do
      @email_message.should be_valid
    end

    it 'invalid when no sub_unit_ids when send_to_sub_units selected' do
      @email_message.send_to_option = 3
      @email_message.should_not be_valid
      @email_message.should have(1).error_on(:base)
    end

    it 'valid when sub_unit_ids when send_to_sub_units selected' do
      @email_message.send_to_option = 3
      @email_message.sub_unit_ids = [1]
      @email_message.should be_valid
    end

    it 'invalid when no user_ids when send_to_users selected' do
      @email_message.send_to_option = 4
      @email_message.should_not be_valid
      @email_message.should have(1).error_on(:base)
    end

    it 'valid when sub_unit_ids when send_to_users selected' do
      user = FactoryGirl.create(:adult)
      @email_message.send_to_option = 4
      @email_message.user_ids = [user.id]
      @email_message.should be_valid
    end

    it 'creates an id_token' do
      @email_message.save
      @email_message.id_token.should_not be_blank
    end
  end


  context '.send_to(unit)' do
    before do
      @email_message = FactoryGirl.build(:email_message, unit: @unit1)
      # @sub_unit = FactoryGirl.create(:sub_unit, unit: @unit)
    end

    context 'with associated unit' do
      it 'returns Everyone in Unit when send_to_unit selected' do
        @email_message.send_to_option = 1
        @email_message.send_to.should eq("Everyone in Cub Scout Pack 134")
      end

      it 'returns All Unit Leaders when send_to_leaders selected' do
        @email_message.send_to_option = 2
        @email_message.send_to.should eq("All Cub Scout Pack 134 Leaders")
      end

      it 'returns Selected SubUnits when send_to_sub_units selected' do
        @email_message.send_to_option = 3
        @email_message.send_to.should eq("Selected Dens")
      end

      it 'returns Selected Adults/Scouts when send_to_users selected' do
        @email_message.send_to_option = 4
        @email_message.send_to.should eq("Selected Adults/Scouts")
      end
    end


    context 'with specified unit' do
      before { @unit2 = FactoryGirl.create(:unit, unit_type: 'Boy Scouts', unit_number: '555') }
      it 'returns Everyone in Unit when send_to_unit selected' do
        @email_message.send_to_option = 1
        @email_message.send_to(@unit2).should eq("Everyone in Boy Scout Troop 555")
      end

      it 'returns All Unit Leaders when send_to_leaders selected' do
        @email_message.send_to_option = 2
        @email_message.send_to(@unit2).should eq("All Boy Scout Troop 555 Leaders")
      end

      it 'returns Selected SubUnits when send_to_sub_units selected' do
        @email_message.send_to_option = 3
        @email_message.send_to(@unit2).should eq("Selected Patrols")
      end

      it 'returns Selected Adults/Scouts when send_to_users selected' do
        @email_message.send_to_option = 4
        @email_message.send_to(@unit2).should eq("Selected Adults/Scouts")
      end
    end
  end

  # context '.has_attachments?' do
  #   before do
  #     @email_message = FactoryGirl.create(:email_message)
  #     @email_attachment = EmailAttachment.create()
  #   end
  # end

  context '.has_events?' do
    before do
      @event = FactoryGirl.create(:event)
      @email_message = FactoryGirl.create(:email_message)
    end

    it 'returns FALSE when no associated events' do
      @email_message.has_events?.should be_false
    end

    it 'returns TRUE when it has associated events' do
      @email_message.events << @event
      @email_message.has_events?.should be_true
    end
  end


  context '.events_have_signups?' do
    before do
      @event = FactoryGirl.create(:event)
      # @event_signup = FactoryGirl.create(:event_signup)
      @email_message = FactoryGirl.create(:email_message)
      @email_message.events << @event
    end

    it 'returns TRUE when email message has an event that has signup required' do
      @event.update_attribute(:signup_required, true)
      @email_message.events_have_signup?.should be_true
    end

    it 'returns FALSE when email message has an event that does not have signup required' do
      @email_message.events_have_signup?.should be_false
    end
  end


  context '.subject_with_unit' do
    before do
      @unit999 = FactoryGirl.create(:unit, unit_type: "Boy Scouts", unit_number: '535')
      @email_message = FactoryGirl.build(:email_message, unit: @unit999)
    end

    it 'returns the subject with unit name' do
      @email_message.subject = "Home with Homies"
      @email_message.subject_with_unit.should eq("[BS Troop 535] Home with Homies")
    end
  end


  context 'send_to_xxx?' do
    before { @email_message = FactoryGirl.build(:email_message) }

    it 'returns true when send_to_unit' do
      @email_message.send_to_option = 1
      @email_message.send_to_unit?.should be_true
    end

    it 'returns true when send_to_leaders' do
      @email_message.send_to_option = 2
      @email_message.send_to_leaders?.should be_true
    end

    it 'returns true when send_to_sub_units' do
      @email_message.send_to_option = 3
      @email_message.send_to_sub_units?.should be_true
    end

    it 'returns true when send_to_users' do
      @email_message.send_to_option = 4
      @email_message.send_to_users?.should be_true
    end
  end


  context '.recipients' do
    before { @email_message = FactoryGirl.create(:email_message, unit: @unit1) }

    context 'sending to all users in unit' do
      it 'returns all users in a unit with emails' do
        @email_message.recipients.should include(@adult)
      end

      it 'should not return users without emails' do
        @email_message.recipients.should_not include(@adult2)
        @email_message.recipients.should_not include(@scout1)
        @email_message.recipients.should_not include(@scout2)
      end
    end

    context 'sending to unit leaders' do
      before { @email_message.send_to_option = 2 }

      it 'returns all leaders (adults) with emails' do
        @email_message.recipients.should include(@adult)
      end

      it 'should not return users without emails' do
        @email_message.recipients.should_not include(@adult2)
        @email_message.recipients.should_not include(@scout1)
        @email_message.recipients.should_not include(@scout2)
      end
    end

    context 'sending to selected sub units' do
      before do
        @email_message.send_to_option = 3
        @email_message.sub_unit_ids = [@sub_unit1, @sub_unit3]
      end

      it 'returns all user with emails' do
        @email_message.recipients.should include(@adult)
      end

      it 'should not return users without emails' do
        @email_message.recipients.should_not include(@adult2)
        @email_message.recipients.should_not include(@scout1)
        @email_message.recipients.should_not include(@scout2)
      end
    end

    context 'sending to selected users' do
      before do
        @email_message.send_to_option = 4
        @email_message.user_ids = [@adult.id, @scout1.id, @scout2.id]
      end

      it 'returns all users with emails' do
        @email_message.recipients.should include(@adult)
        @email_message.recipients.should include(@scout2)
      end

      it 'should not return users without emails' do
        @email_message.recipients.should_not include(@scout1)
        @email_message.recipients.should_not include(@adult2)
      end
    end
  end


  context '.send_to_count' do
    before { @email_message = FactoryGirl.create(:email_message, unit: @unit1) }

    context 'sending to all users in unit' do
      it 'returns count of all users in unit' do
        @email_message.send_to_count.should be(1)
      end
    end

    context 'sending to unit leaders with emails' do
      it 'returns count of all leaders (adults) with emails' do
        @email_message.send_to_option = 2
        @email_message.send_to_count.should be(1)
      end
    end

    context 'sending to selected sub units' do
      it 'returns cout of all user with emails' do
        @email_message.send_to_option = 3
        @email_message.sub_unit_ids = [@sub_unit1, @sub_unit3]
        @email_message.send_to_count.should be(1)
      end
    end

    context 'sending to selected users' do
      it 'returns cout of all users with emails' do
        @email_message.send_to_option = 4
        @email_message.user_ids = [@adult.id, @scout1.id, @scout2.id]
        @email_message.send_to_count.should be(2)
      end
    end
  end


  context '.recipients_emails' do
    before { @email_message = FactoryGirl.create(:email_message, unit: @unit1) }

    context 'sending to all users in unit' do
      it 'returns all users in a unit with emails' do
        @email_message.recipients_emails.should include(@adult.email)
      end

      it 'should not return users without emails' do
        @email_message.recipients_emails.should_not include(@adult2.email)
        @email_message.recipients_emails.should_not include(@scout1.email)
        @email_message.recipients_emails.should_not include(@scout2.email)
      end
    end

    context 'sending to unit leaders' do
      before { @email_message.send_to_option = 2 }

      it 'returns all leaders (adults) with emails' do
        @email_message.recipients_emails.should include(@adult.email)
      end

      it 'should not return users without emails' do
        @email_message.recipients_emails.should_not include(@adult2.email)
        @email_message.recipients_emails.should_not include(@scout1.email)
        @email_message.recipients_emails.should_not include(@scout2.email)
      end
    end

    context 'sending to selected sub units' do
      before do
        @email_message.send_to_option = 3
        @email_message.sub_unit_ids = [@sub_unit1, @sub_unit3]
      end

      it 'returns all user with emails' do
        @email_message.recipients_emails.should include(@adult.email)
      end

      it 'should not return users without emails' do
        @email_message.recipients_emails.should_not include(@adult2.email)
        @email_message.recipients_emails.should_not include(@scout1.email)
        @email_message.recipients_emails.should_not include(@scout2.email)
      end
    end

    context 'sending to selected users' do
      before do
        @email_message.send_to_option = 4
        @email_message.user_ids = [@adult.id, @scout1.id, @scout2.id]
      end

      it 'returns all users with emails' do
        @email_message.recipients_emails.should include(@adult.email)
        @email_message.recipients_emails.should include(@scout2.email)
      end

      it 'should not return users without emails' do
        @email_message.recipients_emails.should_not include(@scout1.email)
        @email_message.recipients_emails.should_not include(@adult2.email)
      end
    end
  end

end
