require 'rails_helper'

RSpec.describe EmailMessage do
  before(:all) do
    adult_2units_2scout_3subunits
    @adult3 = FactoryGirl.create(:adult, email: nil)
    @adult3.units << @unit1 # add adult with no email
  end

  let(:email_message) { FactoryGirl.build(:email_message, unit: @unit1) }
  let(:email_message_c) { FactoryGirl.build_stubbed(:email_message, unit: @unit1) }
  let(:email_message_c_bs) { FactoryGirl.build_stubbed(:email_message, unit: @unit2) }


  it { should belong_to(:sender) }
  it { should belong_to(:unit) }
  it { should belong_to(:email_group) }
  it { should have_many(:email_attachments) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:events) }

  # it { should validate_presence_of(:message) }
  it { should validate_presence_of(:subject) }

  describe 'validations' do
    specify { expect(email_message).to be_valid }


    it 'invalid when no user_ids when send_to_users selected' do
      email_message.send_to_option = 4
      expect(email_message).not_to be_valid
      expect(email_message.errors.count).to eq(1)
      expect(email_message.errors).to include(:base)
    end

    it 'valid when sub_unit_ids when send_to_users selected' do
      user = FactoryGirl.create(:adult)
      email_message.send_to_option = 4
      email_message.user_ids = [user.id]
      expect(email_message).to be_valid
    end

    it 'creates an id_token' do
      email_message.save
      expect(email_message.id_token).not_to be_blank
    end

    describe 'presence of message' do
      it 'required when no events selected' do
        should validate_presence_of(:message)
      end

      it 'not required when events selected' do
        event = FactoryGirl.create(:event)
        email_message.message = nil
        email_message.event_ids = [event.id]
        expect(email_message.valid?).to eq(true)
        expect(email_message.errors).not_to include(:message)
      end
    end
  end


  context '.send_to(unit)' do
    context 'with associated unit' do
      it 'returns Everyone in Unit when send_to_unit selected' do
        email_message.send_to_option = 1
        expect(email_message.send_to).to eq("Everyone in Cub Scout Pack 134")
      end

      it 'returns All Unit Leaders when send_to_leaders selected' do
        email_message.send_to_option = 2
        expect(email_message.send_to).to eq("All Cub Scout Pack 134 Leaders")
      end

      it 'returns Selected SubUnits when send_to_sub_units selected' do
        email_message.send_to_option = 3
        expect(email_message.send_to).to eq("Selected Dens")
      end

      it 'returns Selected Adults/Scouts when send_to_users selected' do
        email_message.send_to_option = 4
        expect(email_message.send_to).to eq("Selected Adults/Scouts")
      end

      it 'returns Scoutmasters when send_to_scoutmasters selected' do
        email_message.send_to_option = 5
        expect(email_message.send_to).to eq("Scoutmasters (SM/ASM)")
      end
    end


    context 'with specified unit' do
      let(:unit2) { FactoryGirl.build(:unit, unit_type: 'Boy Scouts', unit_number: '555') }

      it 'returns Everyone in Unit when send_to_unit selected' do
        email_message.send_to_option = 1
        expect(email_message.send_to(unit2)).to eq("Everyone in Boy Scout Troop 555")
      end

      it 'returns All Unit Leaders when send_to_leaders selected' do
        email_message.send_to_option = 2
        expect(email_message.send_to(unit2)).to eq("All Boy Scout Troop 555 Leaders")
      end

      it 'returns Selected SubUnits when send_to_sub_units selected' do
        email_message.send_to_option = 3
        expect(email_message.send_to(unit2)).to eq("Selected Patrols")
      end

      it 'returns Selected Adults/Scouts when send_to_users selected' do
        email_message.send_to_option = 4
        expect(email_message.send_to(unit2)).to eq("Selected Adults/Scouts")
      end

      it 'returns Scoutmasters when send_to_scoutmasters selected' do
        email_message.send_to_option = 5
        expect(email_message.send_to(unit2)).to eq("Scoutmasters (SM/ASM)")
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
      expect(@email_message.has_events?).to eq(false)
    end

    it 'returns TRUE when it has associated events' do
      @email_message.events << @event
      expect(@email_message.has_events?).to eq(true)
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
      expect(@email_message.events_have_signup?).to eq(true)
    end

    it 'returns FALSE when email message has an event that does not have signup required' do
      expect(@email_message.events_have_signup?).to eq(false)
    end
  end


  context '.subject_with_unit' do
    before do
      @unit999 = FactoryGirl.build_stubbed(:unit, unit_type: "Boy Scouts", unit_number: '535')
      @email_message = FactoryGirl.build(:email_message, unit: @unit999)
    end

    it 'returns the subject with unit name' do
      @email_message.subject = "Home with Homies"
      expect(@email_message.subject_with_unit).to eq("Home with Homies [BS Troop 535]")
    end
  end




  context '.recipients' do
    context 'sending to all users in unit' do
      it 'returns all users in a unit with emails' do
        expect(email_message_c.recipients).to include(@adult)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients).not_to include(@adult3)
        expect(email_message_c.recipients).not_to include(@scout1)
        expect(email_message_c.recipients).not_to include(@scout2)
      end
    end

    context 'sending to unit leaders' do
      before { email_message_c.send_to_option = 2 }

      it 'returns all leaders (adults) with emails' do
        expect(email_message_c.recipients).to include(@adult)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients).not_to include(@adult3)
        expect(email_message_c.recipients).not_to include(@scout1)
        expect(email_message_c.recipients).not_to include(@scout2)
      end
    end

    context 'sending to selected sub units' do
      before do
        email_message_c.send_to_option = 3
        email_message_c.sub_unit_ids = [@sub_unit1, @sub_unit3]
      end

      it 'returns all user with emails' do
        expect(email_message_c.recipients).to include(@adult)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients).not_to include(@adult3)
        expect(email_message_c.recipients).not_to include(@scout1)
        expect(email_message_c.recipients).not_to include(@scout2)
      end
    end

    context 'sending to selected users' do
      before do
        email_message_c.send_to_option = 4
        email_message_c.user_ids = [@adult.id, @scout1.id, @scout2.id, @scout_related_u1.id]
      end

      it 'returns all users with emails' do
        expect(email_message_c.recipients).to include(@adult)
      end

      it 'includes related adults that are not seleted, but their scout is' do
        expect(email_message_c.recipients).to include(@adult_related_u1)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients).not_to include(@scout2)
        expect(email_message_c.recipients).not_to include(@scout1)
        expect(email_message_c.recipients).not_to include(@adult3)
        expect(email_message_c.recipients).not_to include(@scout_related_u1)
      end
    end

    context 'sending to scoutmasters' do
      before { email_message_c_bs.send_to_option = 5 }

      it 'returns users with Scoutmaster position' do
        expect(email_message_c_bs.recipients).to include(@adult2)
      end

      it 'does not return users without Scoutmaster positions' do
        expect(email_message_c_bs.recipients).not_to include(@adult)
        expect(email_message_c_bs.recipients).not_to include(@adult3)
        expect(email_message_c_bs.recipients).not_to include(@scout1)
        expect(email_message_c_bs.recipients).not_to include(@scout_related_u1)
      end

    end
  end




  context '.recipients_emails' do
    context 'sending to all users in unit' do
      it 'returns all users in a unit with emails' do
        expect(email_message_c.recipients_emails).to include(@adult.email)
        expect(email_message_c.recipients_emails).to include(@adult_related_u1.email)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients_emails).not_to include(@adult2.email)
        expect(email_message_c.recipients_emails).not_to include(@scout1.email)
        expect(email_message_c.recipients_emails).not_to include(@scout2.email)
        expect(email_message_c.recipients_emails).not_to include(@scout_related_u1.email)
      end
    end

    context 'sending to unit leaders' do
      before { email_message_c.send_to_option = 2 }

      it 'returns all leaders (adults) with emails' do
        expect(email_message_c.recipients_emails).to include(@adult.email)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients_emails).not_to include(@adult2.email)
        expect(email_message_c.recipients_emails).not_to include(@scout1.email)
        expect(email_message_c.recipients_emails).not_to include(@scout2.email)
      end
    end

    context 'sending to selected sub units' do
      before do
        email_message_c.send_to_option = 3
        email_message_c.sub_unit_ids = [@sub_unit1, @sub_unit3]
      end

      it 'returns all user with emails' do
        expect(email_message_c.recipients_emails).to include(@adult.email)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients_emails).not_to include(@adult2.email)
        expect(email_message_c.recipients_emails).not_to include(@scout1.email)
        expect(email_message_c.recipients_emails).not_to include(@scout2.email)
      end
    end

    context 'sending to selected users' do
      before do
        email_message_c.send_to_option = 4
        email_message_c.user_ids = [@adult.id, @scout1.id, @scout2.id]
      end

      it 'returns all users with emails' do
        puts email_message_c.recipients_emails
        expect(email_message_c.recipients_emails).to include(@adult.email)
        # expect(email_message_c.recipients_emails).to include(@scout2.email)
      end

      it 'should not return users without emails' do
        expect(email_message_c.recipients_emails).not_to include(@scout1.email)
        expect(email_message_c.recipients_emails).not_to include(@adult2.email)
      end
    end

    context 'send to scoutmasters' do
      before { email_message_c_bs.send_to_option = 5 }

      it 'returns all users with emails' do
        expect(email_message_c_bs.recipients_emails).to include(@adult2.email)
      end

      it 'should not return users without emails' do
        expect(email_message_c_bs.recipients_emails).not_to include(@adult.email)
        expect(email_message_c_bs.recipients_emails).not_to include(@adult3.email)
        expect(email_message_c_bs.recipients_emails).not_to include(@scout2.email)
      end
    end

  end



  # SENT_TO_HASH is set in the mailer, therefore it will always return 0 unless actual mail is sent
  # context '.sent_to_count' do
  #   before { @email_message = FactoryGirl.create(:email_message, unit: @unit1) }

  #   context 'sending to all users in unit' do
  #     it 'returns count of all users in unit' do
  #       @email_message.sent_to_count.should be(2) # @adult and @scout3
  #     end
  #   end

  #   context 'sending to unit leaders with emails' do
  #     it 'returns count of all leaders (adults) with emails' do
  #       @email_message.send_to_option = 2
  #       @email_message.sent_to_count.should be(1)
  #     end
  #   end

  #   context 'sending to selected sub units' do
  #     it 'returns count of all user with emails' do
  #       @email_message.send_to_option = 3
  #       @email_message.sub_unit_ids = [@sub_unit1, @sub_unit3]
  #       @email_message.sent_to_count.should be(1)
  #     end
  #   end

  #   context 'sending to selected users' do
  #     it 'returns count of all users with emails' do
  #       @email_message.send_to_option = 4
  #       @email_message.user_ids = [@adult.id, @scout1.id, @scout2.id]
  #       @email_message.sent_to_count.should be(2)
  #     end
  #   end
  # end
end
