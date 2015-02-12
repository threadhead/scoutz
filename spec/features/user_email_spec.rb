require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'User Email Change' do

  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
  end

  before(:each) do
    Warden.test_reset!
    ActionMailer::Base.deliveries.clear

    @unit = FactoryGirl.create(:unit)
    @user1 = FactoryGirl.create(:adult)
    @user1.confirm!
    @user1.units << @unit
    @user2 = FactoryGirl.create(:adult)
    @user2.units << @unit
    @user2.confirm!

    login_as(@user1, scope: :user)
  end

  context 'visiting the change email page' do
    before{ visit edit_unit_user_email_path(@unit, @user1) }

    it 'should show the user current email address' do
      expect(page).to have_content(@user1.email)
    end

    describe 'entering the same email address' do
      before do
        within 'form.edit_adult' do
          fill_in 'New Email', with: @user1.email
          click_button 'Update Email'
        end
      end

      it 'does not send a confirmation email' do
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end

      it 'displayes an alert notifing the user that nothing was changed' do
        expect(page).to have_content('did not enter a different email')
      end
    end

    describe 'entering a new email address' do
      before do
        within 'form.edit_adult' do
          fill_in 'New Email', with: 'joe.smith@aol.com'
          click_button 'Update Email'
        end
      end

      it 'sends a confirmation email to the new email address' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to).to eq(['joe.smith@aol.com'])
        expect(ActionMailer::Base.deliveries.first.body).to have_content("Confirm my email change to: joe.smith@aol.com")
      end
    end
  end

  describe 'when changing anthother user\'s email address' do
    context 'when admin' do
      before do
        @user1.update_attribute(:role, 'admin')
        visit edit_unit_user_email_path(@unit, @user2)
      end

      it '' do
      end


    end
    context 'when not admin' do
    end
  end

      # describe 'clicking the Send welcome email' do
      #   before do
      #     within '#send-welcome-email' do
      #       click_link 'Send Welcome Email'
      #     end
      #   end

      #   it 'should return to the users show page' do
      #     expect(page).to have_content ("Adult: #{@adult.name}")
      #   end

      #   it 'displays a notification of sent email' do
      #     expect(page).to have_content("Welcome email was sent to")
      #   end

      #   it 'sets the users password to nil, creates a password reset token, and sets confirmation' do
      #     @adult.reload
      #     expect(@adult.confirmed_at).not_to be_nil
      #     expect(@adult.reset_password_token).not_to be_nil
      #     expect(@adult.reset_password_sent_at).to be_within(2).of(72.hours.from_now - Devise.reset_password_within)
      #     expect(@adult.encrypted_password).to be_nil
      #   end

      #   it 'sends and email to the reset user' do
      #     expect(ActionMailer::Base.deliveries.size).to eq(1)
      #     expect(ActionMailer::Base.deliveries.first.to).to eq([@adult.email])
      #     expect(ActionMailer::Base.deliveries.first.subject).to eq("Welcome to Scoutt.in!")
      #   end
      # end

  # context 'as s welcomed user' do
  #   before do
  #     logout
  #     @adult = FactoryGirl.create(:adult)
  #     @adult.confirm!
  #     @adult.units << @unit
  #     token = @adult.send(:set_reset_password_token)
  #     @adult.reset_password_sent_at = 72.hours.from_now - Devise.reset_password_within
  #     @adult.encrypted_password = nil
  #     @adult.save(validate: false)
  #     # puts "adult.reset_password_token: #{@adult.reset_password_token}"
  #     visit user_welcome_edit_url(reset_password_token: token)
  #   end

  #   it 'displays the welcome page' do
  #     expect(page).to have_content("Welcome to Scoutt.in")
  #     expect(page).to have_button("Create my password")
  #   end

  #   context 'entering valid password/confirmation' do
  #     before do
  #       within '#new_user' do
  #         fill_in 'Password', with: 'asdf1234'
  #         fill_in 'Password confirmation', with: 'asdf1234'
  #       end
  #       click_button 'Create my password'
  #     end

  #     it 'saves new password' do
  #       @adult.reload
  #       expect(@adult.confirmed?).to eq(true)
  #       expect(@adult.reset_password_sent_at).to be_nil
  #       expect(@adult.password).not_to be_nil
  #     end

  #     it 'takes the user to the dashboard (events#list)' do
  #       expect(page).to have_content('Upcoming Events')
  #       expect(page).to have_link('Sign out')
  #     end
  #   end

  #   context 'entering invalid password/confirmation' do
  #     describe 'password is too short' do
  #       it 'displays an error in the alert div' do
  #         within '#new_user' do
  #           fill_in 'Password', with: 'asdf'
  #           fill_in 'Password confirmation', with: 'asdf'
  #         end
  #         click_button 'Create my password'
  #         expect(page).to have_css("div.alert.alert-danger")
  #         expect(page).to have_content("Password is too short")
  #       end
  #     end


  #     describe 'password/confirmation do not match' do
  #       it 'displays an error in the alert div' do
  #         within '#new_user' do
  #           fill_in 'Password', with: 'asdf1234'
  #           fill_in 'Password confirmation', with: 'asdf4321'
  #         end
  #         click_button 'Create my password'

  #         expect(page).to have_css("div.alert.alert-danger")
  #         expect(page).to have_content("Password confirmation doesn't match Password")
  #       end
  #     end


  #     describe 'user is allowed to continue after invalid entry' do
  #       it 'saves the users new pasword' do
  #         within '#new_user' do
  #           fill_in 'Password', with: 'asdf1234'
  #           fill_in 'Password confirmation', with: 'asdf4321'
  #         end
  #         click_button 'Create my password'

  #         within '#edit_user' do
  #           fill_in 'Password', with: 'asdf1234'
  #           fill_in 'Password confirmation', with: 'asdf1234'
  #         end
  #         click_button 'Create my password'

  #         @adult.reload
  #         expect(@adult.confirmed?).to eq(true)
  #         expect(@adult.reset_password_sent_at).to be_nil
  #         expect(@adult.password).not_to be_nil
  #       end
  #     end
  #   end

  # end

end
