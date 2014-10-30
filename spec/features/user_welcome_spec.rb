require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'User Welcome Email and Password Reset' do

  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
    create_cub_scout_unit
    @adult = FactoryGirl.create(:adult)
    @adult.units << @unit
  end

  before(:each) do
    # Warden.test_reset!
  end

  context 'when admin' do
    before{ login_as(@user, scope: :user) }
    describe 'visiting a users page' do
      before{ visit unit_adult_path(@unit, @adult) }

      it 'should have a link to send welcome eamil' do
        expect(page).to have_link('Send welcome email')
      end

      describe 'clicking the Send welcome email' do
        before do
          ActionMailer::Base.deliveries.clear
          within '#send-welcome-email' do
            click_link 'Send welcome email'
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

end
