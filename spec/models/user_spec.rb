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

end
