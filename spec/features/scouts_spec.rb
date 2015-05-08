require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Scouts' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before { login_as(@user, scope: :user) }

    context 'when viewing a list of unit scouts' do
      before { visit unit_scouts_path(@unit) }
      it 'shows the scout list' do
        expect(page.current_path).to eq(unit_scouts_path(@unit))
      end
    end



    context 'when adding a new scout' do
      before { visit new_unit_scout_path(@unit) }

      it 'displays the form page' do
        expect(page.current_path).to eq(new_unit_scout_path(@unit))
        expect(page).to have_text('New Scout in Cub Scout Pack 134')
      end
    end



    context 'when showing an existing scout' do
      before { visit unit_scout_path(@unit, @scout1) }

      it 'displays the scout show page' do
        expect(page.current_path).to eq(unit_scout_path(@unit, @scout1))
        expect(page).to have_text("Scout: #{@scout1.name}")
      end
    end



    context 'deleting an adult' do
      before do
        @del_scout = FactoryGirl.create(:scout)
        @del_scout.units << @unit
        visit unit_scout_path(@unit, @del_scout)
      end

      it 'deletes the user and returns to the adult list' do
        click_link "Destroy #{@del_scout.first_name}"

        expect(page.current_path).to eq(unit_scouts_path(@unit))
      end
    end



    context 'editing an adult' do
      before do
        @edit_scout = FactoryGirl.create(:scout)
        @edit_scout.units << @unit
        visit unit_scout_path(@unit, @edit_scout)

        click_link "Edit"
      end

      after { @edit_scout.destroy }

      it 'displays the edit form page' do
        expect(page.current_path).to eq(edit_unit_scout_path(@unit, @edit_scout))
        expect(page).to have_text("Edit Scout")
      end

    end
  end
end
