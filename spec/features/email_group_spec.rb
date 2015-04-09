require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Email Groups' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
    @eg = FactoryGirl.create(:email_group, name: "Friends999", unit: @unit, user: @user, users_ids: [@user.id, @scout2.id])
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before{ login_as(@user, scope: :user) }

    context 'when viewing a list of unit email groups' do
      before{ visit unit_email_groups_path(@unit) }
      it 'shows the group list' do
        expect(page.current_path).to eq(unit_email_groups_path(@unit))
      end
    end


    context 'adding a new group' do
      before { visit new_unit_email_group_path(@unit) }

      it 'displays the form page' do
        expect(page.current_path).to eq(new_unit_email_group_path(@unit))
        expect(page).to have_text('New Email Group for Cub Scout Pack 134')
      end
    end



    # MERIT BADGES are imported, not manually created
    # context 'when adding a new merit badge' do
    #   before { visit new_unit_merit_badge_path(@unit) }

    #   it 'displays the form page' do
    #     expect(page.current_path).to eq(new_unit_merit_badge_path(@unit))
    #   end
    # end



    context 'when showing an existing email group' do
      before{ visit unit_email_group_path(@unit, @eg) }

      it 'displays the group show page' do
        expect(page.current_path).to eq(unit_email_group_path(@unit, @eg))
        expect(page).to have_text("Friends999")
      end
    end



    context 'editing an email group' do
      before do
        visit unit_email_group_path(@unit, @eg)

        click_link "Edit"
      end

      it 'displays the edit form page' do
        expect(page.current_path).to eq(edit_unit_email_group_path(@unit, @eg))
        expect(page).to have_text("Edit Friends999 Email Group")
      end
    end

    context 'deleting an email group' do
      before do
        @eg2 = FactoryGirl.create(:email_group, name: "Monster888", unit: @unit, user: @user, users_ids: [@user.id, @scout2.id])
        visit unit_email_group_path(@unit, @eg2)
      end

      it 'deletes the group and returns to the group list' do
        click_link "Destroy Monster888"

        expect(EmailGroup.where(id: @eg2.id).exists?).to be(false)
        expect(page.current_path).to eq(unit_email_groups_path(@unit))
      end
    end

  end
end
