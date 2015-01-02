require 'rails_helper'

RSpec.describe 'User relations are touched' do

  context 'creating and associating users' do
    context 'adult removing scouts' do
      it 'touches users when added to relation' do
        scout1 = FactoryGirl.create(:scout, first_name: 'scout1')
        scout1.update_column(:updated_at, 1.year.ago)
        scout2 = FactoryGirl.create(:scout, first_name: 'scout2')
        scout2.update_column(:updated_at, 1.year.ago)

        adult = FactoryGirl.create(:adult)
        adult.scouts << scout1
        expect(scout1.reload.updated_at).to be_within(2).of(Time.now)
        expect(scout2.updated_at).to be_within(2).of(1.year.ago)
        adult.scouts << scout2
        expect(scout2.reload.updated_at).to be_within(2).of(Time.now)
      end
    end

    context 'scout removing adults' do
      it 'touches users when added to relation' do
        adult = FactoryGirl.create(:adult)
        adult.update_column(:updated_at, 1.year.ago)
        scout1 = FactoryGirl.create(:scout, first_name: 'scout1')

        expect(adult.updated_at).to be_within(2).of(1.year.ago)
        scout1.adults << adult
        expect(adult.updated_at).to be_within(2).of(Time.now)
      end
    end
  end

  context 'existing users' do
    before do
      @adult = FactoryGirl.create(:adult)
      @scout1 = FactoryGirl.build(:scout, first_name: 'scout1')
      @scout2 = FactoryGirl.build(:scout, first_name: 'scout2')
      @adult.scouts << [@scout1, @scout2]
      @scout1.update_column(:updated_at, 1.year.ago)
      @scout2.update_column(:updated_at, 1.year.ago)
    end

    describe 'removing relation' do
      context 'adult removeing scouts' do
        it 'touches users when relation is removed' do
          @scout1.update_column(:updated_at, 1.year.ago)
          @scout2.update_column(:updated_at, 1.year.ago)
          @adult.scouts.delete @scout2
          expect(@scout1.reload.updated_at).to be_within(2).of(1.year.ago)
          expect(@scout2.reload.updated_at).to be_within(2).of(Time.now)
          @adult.scouts.delete @scout1
          expect(@scout1.reload.updated_at).to be_within(2).of(Time.now)
        end
      end

      context 'scout removing adults' do
        it 'touches users when relation is removed' do
          @adult.update_column(:updated_at, 1.year.ago)
          @scout1.adults.delete @adult
          expect(@adult.reload.updated_at).to be_within(2).of(Time.now)
        end
      end
    end


    describe 'updating' do
      context 'an adult' do
        it 'all related scouts are touched' do
          @adult.update_attribute(:first_name, 'simon')
          expect(@scout1.reload.updated_at).to be_within(2).of(Time.now)
          expect(@scout2.reload.updated_at).to be_within(2).of(Time.now)
        end
      end

      context 'a scout' do
        before { @scout1.update_attribute(:first_name, 'simon') }
        specify { expect(@adult.reload.updated_at).to be_within(2).of(Time.now) }
      end

      context 'a second scout' do
        before { @scout2.update_attribute(:first_name, 'simon') }
        specify { expect(@adult.reload.updated_at).to be_within(2).of(Time.now) }
      end
    end

    describe 'destroying' do
      context 'an adult' do
        it 'all realted scouts are touched' do
          @adult.destroy
          expect(@scout1.reload.updated_at).to be_within(2).of(Time.now)
          expect(@scout2.reload.updated_at).to be_within(2).of(Time.now)
        end
      end

      context 'a scout' do
        before { @scout1.destroy }
        specify { expect(@adult.reload.updated_at).to be_within(2).of(Time.now) }
      end

      context 'a second scout' do
        before { @scout2.destroy }
        specify { expect(@adult.reload.updated_at).to be_within(2).of(Time.now) }
      end
    end
  end

end
