require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Merit Badges' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
    @mb1 = FactoryGirl.create(:merit_badge, name: "Engineering")
    @mb2 = FactoryGirl.create(:merit_badge, name: "Welding")
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before { login_as(@user, scope: :user) }

    context 'when viewing a list of unit merit badges' do
      before { visit unit_merit_badges_path(@unit) }
      it 'shows the scout list' do
        expect(page.current_path).to eq(unit_merit_badges_path(@unit))
      end
    end


    # MERIT BADGES are imported, not manually created
    # context 'when adding a new merit badge' do
    #   before { visit new_unit_merit_badge_path(@unit) }

    #   it 'displays the form page' do
    #     expect(page.current_path).to eq(new_unit_merit_badge_path(@unit))
    #   end
    # end



    context 'when showing an existing merit badge' do
      before { visit unit_merit_badge_path(@unit, @mb1) }

      it 'displays the scout show page' do
        expect(page.current_path).to eq(unit_merit_badge_path(@unit, @mb1))
        expect(page).to have_text("Merit Badge: Engineering")
      end
    end



    context 'editing a merit badge' do
      before do
        visit unit_merit_badge_path(@unit, @mb1)

        click_link "Edit"
      end

      it 'displays the edit form page' do
        expect(page.current_path).to eq(edit_unit_merit_badge_path(@unit, @mb1))
        expect(page).to have_text("Edit Merit Badge Counselors")
      end

    end
  end
end
