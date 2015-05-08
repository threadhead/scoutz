require 'rails_helper'
# include Warden::Test::Helpers

RSpec.describe 'Adults' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    # WebMock.disable!
    Warden.test_mode!
    create_cub_scout_unit
    @unit2 = FactoryGirl.create(:unit, unit_type: 'Boy Scouts', unit_number: '330')
    @user.units << @unit2
    sign_in_user(@user.email, 'sekritsekrit')
  end

  # before(:each) do
  # Warden.test_reset!
  # login_as(@user, scope: :user)
  # visit unit_events_path(@unit)
  # end

  it 'selecting a unit in the default_unit switches to that unit\'s event list' do
    expect(page).to have_select('select_default_unit', ['CS Pack 134', 'BS Troop 330'])
    select 'BS Troop 330', from: 'select_default_unit'
    visit change_default_unit_units_path(select_default_unit: 2)

    expect(page).to have_text('Troop 330 Upcoming Events')
    # click_link "Welcome, Tara"
    # click_link 'Sign out'
  end

  # it 'second test' do
  #   puts "user count: #{User.count}"
  #   visit unit_events_path(@unit)
  #   within("#new_user") do
  #     fill_in 'Email', with: @user.email
  #     fill_in 'Password', with: 'sekritsekrit'
  #   end
  #   click_button 'Sign in'

  #   screenshot_and_save_page
  # end
end
