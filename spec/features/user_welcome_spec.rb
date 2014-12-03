require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'User Welcome Email and Password Reset' do

  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
    create_cub_scout_unit
  end

  before(:each) do
    Warden.test_reset!
    ActionMailer::Base.deliveries.clear
  end

  context 'when admin' do
    before do
      @adult = FactoryGirl.create(:adult)
      @adult.confirm!
      @adult.units << @unit
      login_as(@user, scope: :user)
    end
    describe 'visiting a users page' do
      before{ visit unit_adult_path(@unit, @adult) }

      it 'should have a link to send welcome eamil' do
        expect(page).to have_link('Send Welcome Email')
      end

      describe 'clicking the Send welcome email' do
        before do
          within '#send-welcome-email' do
            click_link 'Send Welcome Email'
          end
        end

        it 'should return to the users show page' do
          expect(page).to have_content ("Adult: #{@adult.name}")
        end

        it 'displays a notification of sent email' do
          expect(page).to have_content("Welcome email was sent to")
        end

        it 'sets the users password to nil, creates a password reset token, and sets confirmation' do
          @adult.reload
          expect(@adult.confirmed_at).not_to be_nil
          expect(@adult.reset_password_token).not_to be_nil
          expect(@adult.reset_password_sent_at).to be_within(2).of(72.hours.from_now - Devise.reset_password_within)
          expect(@adult.encrypted_password).to be_nil
        end

        it 'sends and email to the reset user' do
          expect(ActionMailer::Base.deliveries.size).to eq(1)
          expect(ActionMailer::Base.deliveries.first.to).to eq([@adult.email])
          expect(ActionMailer::Base.deliveries.first.subject).to eq("Welcome to Scoutt.in!")
        end
      end
    end
  end

  context 'as s welcomed user' do
    before do
      logout
      @adult = FactoryGirl.create(:adult)
      @adult.confirm!
      @adult.units << @unit
      token = @adult.send(:set_reset_password_token)
      @adult.reset_password_sent_at = 72.hours.from_now - Devise.reset_password_within
      @adult.encrypted_password = nil
      @adult.save(validate: false)
      # puts "adult.reset_password_token: #{@adult.reset_password_token}"
      visit user_welcome_edit_url(reset_password_token: token)
    end

    it 'displays the welcome page' do
      expect(page).to have_content("Welcome to Scoutt.in")
      expect(page).to have_button("Create my password")
    end

    context 'entering valid password/confirmation' do
      before do
        within '#new_user' do
          fill_in 'Password', with: 'asdf1234'
          fill_in 'Password confirmation', with: 'asdf1234'
        end
        click_button 'Create my password'
      end

      it 'saves new password' do
        @adult.reload
        expect(@adult.confirmed?).to eq(true)
        expect(@adult.reset_password_sent_at).to be_nil
        expect(@adult.password).not_to be_nil
      end

      it 'takes the user to the dashboard (events#list)' do
        expect(page).to have_content('Upcoming Events')
        expect(page).to have_link('Sign out')
      end
    end

    context 'entering invalid password/confirmation' do
      describe 'password is too short' do
        it 'displays an error in the alert div' do
          within '#new_user' do
            fill_in 'Password', with: 'asdf'
            fill_in 'Password confirmation', with: 'asdf'
          end
          click_button 'Create my password'
          expect(page).to have_css("div.alert.alert-danger")
          expect(page).to have_content("Password is too short")
        end
      end


      describe 'password/confirmation do not match' do
        it 'displays an error in the alert div' do
          within '#new_user' do
            fill_in 'Password', with: 'asdf1234'
            fill_in 'Password confirmation', with: 'asdf4321'
          end
          click_button 'Create my password'

          expect(page).to have_css("div.alert.alert-danger")
          expect(page).to have_content("Password confirmation doesn't match Password")
        end
      end


      describe 'user is allowed to continue after invalid entry' do
        it 'saves the users new pasword' do
          within '#new_user' do
            fill_in 'Password', with: 'asdf1234'
            fill_in 'Password confirmation', with: 'asdf4321'
          end
          click_button 'Create my password'

          within '#edit_user' do
            fill_in 'Password', with: 'asdf1234'
            fill_in 'Password confirmation', with: 'asdf1234'
          end
          click_button 'Create my password'

          @adult.reload
          expect(@adult.confirmed?).to eq(true)
          expect(@adult.reset_password_sent_at).to be_nil
          expect(@adult.password).not_to be_nil
        end
      end
    end

  end

end
