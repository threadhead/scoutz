require 'rails_helper'

RSpec.describe Deactivatable do
  before(:all) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    ActiveRecord::Schema.define(version: 1) do
      create_table :deactivatable_items do |t|
        t.datetime :deactivated_at
        t.integer :active_changed_by_id
      end
      create_table :deactivatable_dependencies do |t|
        t.datetime :deactivated_at
        t.belongs_to :deactivatable_item
        t.integer :active_changed_by_id
      end
      create_table :deactivatable_users do |t|
        t.string :name
      end
    end

    class DeactivatableUser < ActiveRecord::Base; end
    class DeactivatableItem < ActiveRecord::Base
      include Deactivatable
      has_many :deactivatable_dependencies
      deactivatable_user_resource DeactivatableUser
    end
    class DeactivatableDependency < ActiveRecord::Base
      include Deactivatable
      belongs_to :deactivatable_item
      deactivatable_user_resource DeactivatableUser
    end
  end



  after(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  before(:each) do
    @di = DeactivatableItem.create!
    @dd = @di.deactivatable_dependencies.create!
  end


  context 'new resources' do
    it { expect(@di.active?).to be true }
    it { expect(@di.active_changed_by_id).to be_nil }
    it { expect(@di.deactivated_at).to be_nil }
  end

  context 'when deactivating' do
    before { @di.deactivate! }

    it { expect(@di.active?).to be false }
    it { expect(@di.deactivated_at).to be_within(5).of(Time.now) }
    # it { expect(@di.active_changed_by_id).to be_nil }
  end



  describe '.active_changed_by' do
    before { @user = DeactivatableUser.create! }
    let(:mock_user) { mock_model(User) }

    it 'returns user when set' do
      @di.active_changed_by_id = @user.id
      expect(@di.active_changed_by).to eq(@user)
    end

    it 'returns nil when not set' do
      expect(@di.active_changed_by).to be_nil
    end

    describe 'when deactivating' do
      it 'is set when User.current is available' do
        mock_user = mock_model(DeactivatableUser)
        expect(DeactivatableUser).to receive(:current).and_return(mock_user)
        @di.deactivate!
        expect(@di.active_changed_by_id).to be(mock_user.id)
      end

      it 'is set to nil when User.current is missing' do
        expect(DeactivatableUser).to receive(:current).and_return(nil)
        @di.deactivate!
        expect(@di.active_changed_by_id).to be_nil
      end
    end

    describe 'when activating' do
      it 'is set when User.current is available' do
        mock_user = mock_model(DeactivatableUser)
        expect(DeactivatableUser).to receive(:current).twice.and_return(mock_user)
        @di.deactivate!
        @di.activate!
        expect(@di.active_changed_by_id).to be(mock_user.id)
      end

      it 'is set to nil when User.current is missing' do
        expect(DeactivatableUser).to receive(:current).twice.and_return(nil)
        @di.deactivate!
        @di.activate!
        expect(@di.active_changed_by_id).to be_nil
      end
    end
  end



  context 'scopes' do
    describe 'with new records' do
      before { DeactivatableItem.create! }

      it { expect(DeactivatableItem.active.count).to be(2) }
      it { expect(DeactivatableItem.deactivated.count).to be(0) }

      describe 'then deactive one' do
        before { DeactivatableItem.first.deactivate! }

        it { expect(DeactivatableItem.active.count).to be(1) }
        it { expect(DeactivatableItem.deactivated.count).to be(1) }
      end
    end
  end


  describe 'active_check_box' do
    it { expect(@di).to respond_to(:active_check_box) }
    it { expect(@di).to respond_to(:active_check_box=) }

    describe 'deactivate when active and active_check_box is un-checked' do
      before do
        @di.activate!
        @di.active_check_box = '0'
      end

      it { expect(@di.deactivated_at).to be_within(100).of(Time.now) }
      it { expect(@di.active?).to be false }
    end

    describe 'activate when deactivated and active_check_box is checked' do
      before do
        @di.deactivate!
        @di.active_check_box = '1'
      end

      it { expect(@di.deactivated_at).to be_nil }
      it { expect(@di.active?).to be true }
    end
  end

end
