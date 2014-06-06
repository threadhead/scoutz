require 'spec_helper'

RSpec.describe Adult do
  before(:all) { adult_2units_2scout_3subunits }

  it 'should be valid' do
    expect(FactoryGirl.build(:adult, email: 'karl@gmail.com')).to be_valid
  end

  it 'has type: \'Adult\'' do
    expect(FactoryGirl.build(:adult, email: 'karl@gmail.com').type).to eq('Adult')
  end


  context '.sub_units' do
    it 'returns sub_units through associated scouts' do
      @adult.sub_units.should include(@sub_unit1)
      @adult.sub_units.should include(@sub_unit2)
      @adult.sub_units.should_not include(@sub_unit3)
    end

    it 'returns sub_units restricted by unit' do
      @adult.sub_units(@unit1).should include(@sub_unit1)
      @adult.sub_units(@unit1).should_not include(@sub_unit2)
      @adult.sub_units(@unit1).should_not include(@sub_unit3)

      @adult.sub_units(@unit2).should include(@sub_unit2)
      @adult.sub_units(@unit2).should_not include(@sub_unit1)
      @adult.sub_units(@unit2).should_not include(@sub_unit3)
    end
  end


  context '.unit_scouts' do
    it 'returns associated scouts in a unit' do
      @adult.unit_scouts(@unit1).should include(@scout1)
      @adult.unit_scouts(@unit1).should_not include(@scout2)

      @adult.unit_scouts(@unit2).should include(@scout2)
      @adult.unit_scouts(@unit2).should_not include(@scout1)
    end
  end

  context '.handle_relations_update(unit, updates)' do
    describe 'reassymbles scout_ids with additons and deletions' do
      it 'no modifications, returns full set of scout_ids' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, %w(1 3)).should eq(%w(1 2 3 4))
      end

      it 'adding one new relationship, returns full set plus additions' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, %w(1 3 5)).should eq(%w(1 2 3 4 5))
      end

      it 'adding two new relationships, returns full set plus additions' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, %w(1 3 5 6)).should eq(%w(1 2 3 4 5 6))
      end

      it 'removing one relationships, returns full set minus deletion' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, %w(3)).should eq(%w(2 3 4))
      end

      it 'removing all relationships, returns full set minus deletion' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, []).should eq(%w(2 4))
      end

      it 'add one remove one relationship, returns full with additions and deletions' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, %w(1 5)).should eq(%w(1 2 4 5))
      end

      it 'add multi remove multi relationships, returns full with additions and deletions' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4 5))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3 5))
        @adult.handle_relations_update(@unit1, %w(1 6 7)).should eq(%w(1 2 4 6 7))
      end

      it 'make sure empty update set is cleaned and ignored' do
        allow(@adult).to receive_message_chain(:scouts, :pluck, :map).and_return(%w(1 2 3 4))
        allow(@adult).to receive_message_chain(:unit_scouts, :pluck, :map).and_return(%w(1 3))
        @adult.handle_relations_update(@unit1, ['']).should eq(%w(2 4))
        @adult.handle_relations_update(@unit1, ['', '1']).should eq(%w(1 2 4))
      end

    end
  end
end
