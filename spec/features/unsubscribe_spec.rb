require 'rails_helper'

RSpec.describe 'Unsubscribe' do
  before(:all) { Capybara.default_driver = :rack_test }



  context 'with valid user and event tokens' do
    before { @user = FactoryGirl.create(:user) }

    # subject { page }

    [:event_reminder_email, :weekly_newsletter_email, :blast_email].each do |action|
      context "action: #{action}" do
        describe 'when user is not found' do
          before { visit send("unsubscribe_#{action}_path", id: 'asdfasdf') }

          it 'returns a 404 error' do
            expect(page.status_code).to eq(404)
          end

          it 'does not modify the user' do
            expect(@user.send(action)).to eq(true)
          end
        end

        describe 'when no id param is passed' do
          before { visit send("unsubscribe_#{action}_path") }

          it 'returns a 404 error' do
            expect(page.status_code).to eq(404)
          end

          it 'does not modify the user' do
            expect(@user.send(action)).to eq(true)
          end
        end

        describe 'when user is found' do
          before { visit send("unsubscribe_#{action}_path", id: @user.signup_token) }

          it 'sets the subscription to false' do
            expect(@user.reload.send(action)).to eq(false)
          end

        end

      end
    end
  end
end
