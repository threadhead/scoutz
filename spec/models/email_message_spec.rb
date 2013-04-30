require 'spec_helper'

describe EmailMessage do
  it { should belong_to(:sender) }
  it { should belong_to(:unit) }
  it { should have_many(:email_attachments) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:events) }

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
      @unit = FactoryGirl.create(:unit)
      @email_message = FactoryGirl.build(:email_message, unit: @unit)
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

end
