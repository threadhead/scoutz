require 'spec_helper'

describe User do
	it { should have_many(:phones) }
	it { should have_many(:notifiers) }
	it { should have_many(:parents) }
	it { should have_many(:children) }
	it { should have_many(:parent_child_relationships) }
	it { should have_many(:child_parent_relationships) }
	it { should have_and_belong_to_many(:organizations) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }


  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it 'should have an authentication token' do
  	FactoryGirl.create(:user).authentication_token.empty?.should be_false
  end

  describe 'The parent-child relationships' do
  	it "parent can have many children" do
  		parent = FactoryGirl.create(:user)
  		child1 = FactoryGirl.build(:user)
  		child2 = FactoryGirl.build(:user)
  		parent.children << [child1, child2]
  		parent.children.count.should eq(2)
  		parent.children.first.id.should eq(child1.id)
  	end

  	it "children can have many parents" do
  		child = FactoryGirl.create(:user)
  		parent1 = FactoryGirl.build(:user)
  		parent2 = FactoryGirl.build(:user)
  		child.parents << [parent1, parent2]
  		child.parents.count.should eq(2)
  		child.parents.first.id.should eq(parent1.id)
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
