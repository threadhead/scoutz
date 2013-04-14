require 'spec_helper'

describe 'Email Event Signup' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @user = FactoryGirl.create(:user)
    @user.units << @unit
    @scout = FactoryGirl.create(:scout)
    @user.scouts << @scout
    @event = FactoryGirl.create(:event, signup_required: true, signup_deadline: 1.day.from_now)
  end

  def sign_in_user(email, password)
    visit new_user_session_path
    within("#new_user") do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
    end
    click_button 'Sign in'
  end

  context 'with valid user and event tokens' do
    context 'event signup has not passed' do
    end
  end

  context 'with invalid user or event tokens' do
    it 'returns a 404 with a not-found user token' do
      visit event_email_event_signups_path(@event, user_token: 'abc123', event_token: @event.signup_token)
      page.status_code.should eq(404)
    end

    it 'returns a 404 with a not-found event token' do
      visit event_email_event_signups_path(@event, user_token: @user.signup_token, event_token: 'abc123')
      page.status_code.should eq(404)
    end
  end


end
