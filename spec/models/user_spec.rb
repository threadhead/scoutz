require 'rails_helper'

RSpec.describe User do
	it { is_expected.to have_many(:phones) }
  it { is_expected.to have_many(:notifiers) }
  it { is_expected.to have_many(:email_messages) }
	it { is_expected.to have_many(:sms_messages) }
  it { is_expected.to have_and_belong_to_many(:scouts) }
  it { is_expected.to have_and_belong_to_many(:adults) }
  it { is_expected.to have_and_belong_to_many(:units) }
  it { is_expected.to have_many(:merit_badges).through(:counselors) }
  it { is_expected.to have_many(:counselors) }
  it { is_expected.to have_many(:health_forms) }
  it { is_expected.to have_many(:pages) }
  it { is_expected.to have_many(:unit_positions) }
  it { is_expected.to belong_to(:sub_unit).touch(true) }
	# it { is_expected.to have_many(:adults) }
	# it { is_expected.to have_many(:scouts) }
	# it { is_expected.to have_many(:adult_scout_relationships) }
	# it { is_expected.to have_many(:scout_adult_relationships) }
	# it { is_expected.to have_and_belong_to_many(:units) }

  describe 'validators' do
    before { FactoryGirl.create(:user) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:sl_profile).allow_nil }
  end

  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  # it 'should have an authentication token' do
  # 	FactoryGirl.create(:user).authentication_token.empty?.should be_false
  # end



  describe 'The adult-scout relationships' do
  	it "adult can have many scouts" do
  		adult = FactoryGirl.create(:adult)
  		scout1 = FactoryGirl.build(:scout)
  		scout2 = FactoryGirl.build(:scout)
  		adult.scouts << [scout1, scout2]
  		expect(adult.scouts.count).to eq(2)
      expect(adult.scouts).to include(scout1)
  		expect(adult.scouts).to include(scout2)
      expect(scout1.adults).to include(adult)
      expect(scout2.adults).to include(adult)
  	end

  	it "scouts can have many adults" do
  		scout = FactoryGirl.create(:scout)
  		adult1 = FactoryGirl.build(:adult)
  		adult2 = FactoryGirl.build(:adult)
  		scout.adults << [adult1, adult2]
  		expect(scout.adults.count).to eq(2)
      expect(scout.adults).to include(adult1)
      expect(scout.adults).to include(adult2)
      expect(adult1.scouts).to include(scout)
  		expect(adult2.scouts).to include(scout)
  	end
  end




  context 'creating' do
    describe 'successful when email is blank' do
      # it 'email nil' do
      #   u = FactoryGirl.build(:user, email: '')
      #   u.valid?
      #   puts u.errors.inspect
      # end
      it { FactoryGirl.build(:user, email: '').should be_valid }
      it { FactoryGirl.build(:user, email: nil).should be_valid }
    end

    # describe 'password is set to nil of email is blank' do
      # it { FactoryGirl.create(:user, email: '').encrypted_password.should eq(nil) }
    # end

    it 'email must be unique if not blank' do
      user1 = FactoryGirl.create(:user)
      FactoryGirl.build(:user, email: user1.email).should_not be_valid
    end

    it 'can have multiple users with no email' do
      user1 = FactoryGirl.create(:user, email: '')
      FactoryGirl.build(:user, email: '').should be_valid
    end

    describe 'successful when password is blank' do
      it { FactoryGirl.build(:user, password: '').should be_valid }
      it { FactoryGirl.build(:user, password: nil).should be_valid }
    end

    describe 'successful when email and password are blank' do
      it { FactoryGirl.build(:user, email: '', password: '').should be_valid }
      it { FactoryGirl.build(:user, email: nil, password: '').should be_valid }
      it { FactoryGirl.build(:user, email: '', password: nil).should be_valid }
      it { FactoryGirl.build(:user, email: nil, password: nil).should be_valid }
    end

    describe 'unsucessful when password/confimation do not match' do
      it { User.new(last_name: 'smith', first_name: 'karl', email: 'threadhead@gmail.com', password: 'asdfasdf', password_confirmation: 'fdafdasss').should_not be_valid }
    end

    it 'blank email is saved as nil' do
      user = FactoryGirl.create(:user, email: '')
      user.reload
      user.email.should be_nil
    end

    it 'allows users users with the same f/l name, if no email' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:user, first_name: user.first_name, last_name: user.last_name)
      User.where(first_name: user.first_name, last_name: user.last_name).count.should eq(2)
    end
  end



  context 'updating' do
    it 'can update email address' do
      user1 = FactoryGirl.create(:user)
      user1.skip_reconfirmation!
      user1.update_attributes(email: 'joe_something@yahool.net')
      user1.reload
      user1.email.should eq('joe_something@yahool.net')
    end
  end




  context 'scopes' do
    describe '.unit_leaders' do
      before(:all) do
        @u1 = FactoryGirl.build_stubbed(:unit)
        @a1 = FactoryGirl.create(:adult)
        @a2 = FactoryGirl.create(:adult)
        @a2.unit_positions.create(unit_id: @u1.id, leadership: 'Scoutmaster')
        @a3 = FactoryGirl.create(:adult)
        @a3.unit_positions.create(unit_id: @u1.id, additional: 'Quartermaster')
        @s1 = FactoryGirl.create(:scout)
        @s2 = FactoryGirl.create(:scout)
        @s2.unit_positions.create(unit_id: @u1.id, leadership: 'Scoutmaster')
        @s3 = FactoryGirl.create(:scout)
        @s3.unit_positions.create(unit_id: @u1.id, additional: 'Quartermaster')
      end
      after(:all) { [@u1, @a1, @a2, @a3, @s1, @s2, @s3].each {|d| d.delete } }

      specify { expect(Adult.unit_leaders(@u1).count).to eq(2) }
      specify { expect(Adult.unit_leaders(@u1)).to include(@a3) }
      specify { expect(Adult.unit_leaders(@u1)).to include(@a2) }
      specify { expect(Adult.unit_leaders(@u1)).not_to include(@a1) }

      specify { expect(Scout.unit_leaders(@u1).count).to eq(2) }
      specify { expect(Scout.unit_leaders(@u1)).to include(@s3) }
      specify { expect(Scout.unit_leaders(@u1)).to include(@s2) }
      specify { expect(Scout.unit_leaders(@u1)).not_to include(@s1) }
    end

    describe '.with_email' do
      before(:all) do
        @a1 = FactoryGirl.create(:adult)
        @a2 = FactoryGirl.create(:adult, email: '')
        @a3 = FactoryGirl.create(:adult, email: nil)
        @s1 = FactoryGirl.create(:scout)
        @s2 = FactoryGirl.create(:scout, email: 'adsf@gmail.com')
      end
      after(:all) { [@a1, @a2, @a3, @s1, @s2].each {|d| d.delete } }

      specify { expect(Adult.with_email.count).to eq(1) }
      specify { expect(Adult.with_email).to include(@a1) }
      specify { expect(Adult.with_email).not_to include(@a2) }
      specify { expect(Adult.with_email).not_to include(@a3) }

      specify { expect(Scout.with_email.count).to eq(1) }
      specify { expect(Scout.with_email).to include(@s2) }
      specify { expect(Scout.with_email).not_to include(@s1) }
    end

    describe '.with_sms' do
      describe 'only includes users with both sms_number and sms_provider' do
        before(:all) do
          @a1 = FactoryGirl.create(:adult)
          @a2 = FactoryGirl.create(:adult, sms_number: '8885551212', sms_provider: 'Verizon')
          @a3 = FactoryGirl.create(:adult, sms_number: '8885551212')
          @s1 = FactoryGirl.create(:scout, sms_provider: 'Verizon')
          @s2 = FactoryGirl.create(:scout, sms_number: '8885551212', sms_provider: 'Verizon')
        end
        after(:all) { [@a1, @a2, @a3, @s1, @s2].each {|d| d.delete } }

        specify { expect(Adult.with_sms.count).to eq(1) }
        specify { expect(Adult.with_sms).to include(@a2) }
        specify { expect(Adult.with_sms).not_to include(@a1) }
        specify { expect(Adult.with_sms).not_to include(@a3) }

        specify { expect(Scout.with_sms.count).to eq(1) }
        specify { expect(Scout.with_sms).to include(@s2) }
        specify { expect(Scout.with_sms).not_to include(@s1) }
      end
    end
  end


  context 'roles' do
    let(:user) { FactoryGirl.build(:user) }

    describe '.role_at_least' do
      describe 'returns true when role level is at or above' do
        it 'basic' do
          user.basic!
          expect(user.role_at_least(:basic)).to eq(true)
        end
        it 'leader' do
          user.leader!
          expect(user.role_at_least(:basic)).to eq(true)
          expect(user.role_at_least(:leader)).to eq(true)
        end
        it 'admin' do
          user.admin!
          expect(user.role_at_least(:basic)).to eq(true)
          expect(user.role_at_least(:leader)).to eq(true)
          expect(user.role_at_least(:admin)).to eq(true)
        end
      end

      describe 'returns false when role level is below' do
        it 'inactive' do
          user.inactive!
          expect(user.role_at_least(:basic)).to eq(false)
          expect(user.role_at_least(:leader)).to eq(false)
          expect(user.role_at_least(:admin)).to eq(false)
        end
        it 'basic' do
          user.basic!
          expect(user.role_at_least(:leader)).to eq(false)
          expect(user.role_at_least(:admin)).to eq(false)
        end
        it 'leader' do
          user.leader!
          expect(user.role_at_least(:admin)).to eq(false)
        end
      end
    end

    describe 'User.roles_at_and_above' do
      specify { expect(User.roles_at_and_above(:basic)).to be_a(Hash) }

      it 'returns roles at or below parameter' do
        expect(User.roles_at_and_above(:leader).keys).to include('admin')
        expect(User.roles_at_and_above(:leader).keys).to include('leader')
      end
      it 'does not return roles above parameter' do
        expect(User.roles_at_and_above(:leader).keys).not_to include('basic')
        expect(User.roles_at_and_above(:leader).keys).not_to include('inactive')
      end
    end

    describe 'User.roles_at_and_below' do
      specify { expect(User.roles_at_and_below(:basic)).to be_a(Hash) }

      it 'returns roles at or below parameter' do
        expect(User.roles_at_and_below(:basic).keys).to include('inactive')
        expect(User.roles_at_and_below(:basic).keys).to include('basic')
      end
      it 'does not return roles above parameter' do
        expect(User.roles_at_and_below(:basic).keys).not_to include('leader')
        expect(User.roles_at_and_below(:basic).keys).not_to include('admin')
      end
    end
  end


  context 'when updating or destroying a user' do
    describe 'related users are touched' do
      before do
        @adult = FactoryGirl.create(:adult)
        @scout1 = FactoryGirl.build(:scout)
        @scout2 = FactoryGirl.build(:scout)
        @adult.scouts << [@scout1, @scout2]
      end

      describe 'updating' do
        context 'an adult' do
          before { @adult.update_attribute(:first_name, 'simon') }
          it 'all related scouts are touched' do
            expect(@scout1.updated_at).to be_within(5).of(Time.now)
            expect(@scout2.updated_at).to be_within(5).of(Time.now)
          end
        end

        context 'a scout' do
          before { @scout1.update_attribute(:first_name, 'simon') }
          specify { expect(@adult.updated_at).to be_within(5).of(Time.now) }
        end

        context 'a second scout' do
          before { @scout2.update_attribute(:first_name, 'simon') }
          specify { expect(@adult.updated_at).to be_within(5).of(Time.now) }
        end
      end

      describe 'destroying' do
        context 'an adult' do
          before { @adult.destroy }
          it 'all realted scouts are touched' do
            expect(@scout1.updated_at).to be_within(5).of(Time.now)
            expect(@scout2.updated_at).to be_within(5).of(Time.now)
          end
        end

        context 'a scout' do
          before { @scout1.destroy }
          specify { expect(@adult.updated_at).to be_within(5).of(Time.now) }
        end

        context 'a second scout' do
          before { @scout2.destroy }
          specify { expect(@adult.updated_at).to be_within(5).of(Time.now) }
        end
      end
    end
  end

end
