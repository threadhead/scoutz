require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Landing Page' do
  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
    create_cub_scout_unit
  end

  context 'user not signed in' do
    before { visit root_path }

    it 'visiting the landing page works' do
      expect(page).to have_link('Features')
      expect(page).to have_link('Gallery')
      expect(page).to have_link('Sign up')
      expect(page).to have_link('Sign in')

      expect(page).not_to have_link('Sign out')
      expect(page).not_to have_text('Welcome, Tara')
      expect(page).not_to have_text('Upcoming Events')
    end

    context 'when the user clicks on Sign In' do
      context 'and user does not have a previous session' do
        it 'shows the sign in page' do
          click_link 'Sign in'
          expect(page).to have_field('user[email]')
          expect(page).to have_field('user[password]')
        end
      end

      context 'and the user has a previsou session' do
        it 'shows the event list (dashboard) page' do
          login_as(@user, scope: :user)
          click_link 'Sign in'

          expect(page).to have_link('Sign out')
          expect(page).to have_text('Welcome, Tara')
          expect(page).to have_text('Upcoming Events')
        end
      end
    end

    it 'signing out takes you to landing page' do
      login_as(@user, scope: :user)
      click_link 'Sign in'
      click_link 'Sign out'

      expect(page).to have_link('Sign up')
      expect(page).to have_link('Sign in')
    end
  end

  context 'user signed in' do
    before do
      login_as(@user, scope: :user)
      visit root_path
    end

    it 'redirects user to dashboard (event#index)' do
      expect(page.current_path).to eq(unit_events_path(@unit))
      expect(page).to have_text('Welcome, Tara')
      expect(page).to have_link('Sign out')
    end
  end

end
