require 'spec_helper'

describe User do
	it { should have_many(:phones) }
	it { should have_many(:notifiers) }
  it { should have_and_belong_to_many(:scouts) }
  it { should have_and_belong_to_many(:adults) }
	# it { should have_many(:adults) }
	# it { should have_many(:scouts) }
	# it { should have_many(:adult_scout_relationships) }
	# it { should have_many(:scout_adult_relationships) }
	# it { should have_and_belong_to_many(:units) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }


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

end
