require 'rails_helper'

RSpec.describe 'Email Event Signup' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @user = FactoryGirl.create(:user)
    @user.units << @unit
    @scout = FactoryGirl.create(:scout)
    @user.scouts << @scout
    @event = FactoryGirl.create(:event, unit: @unit, signup_required: true, signup_deadline: 1.day.from_now)
  end

  def sign_in_user(email, password)
    visit new_user_session_path
    within("#new_user") do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
    end
    click_button 'Sign in'
  end

  def existing_signup
    @event_signup = @event.event_signups.create(scout_id: @scout.id, scouts_attending: 1)
  end

  def with_custom_options
    @opts.except(:scouts_attending, :siblings_attending, :adults_attending)
  end

  context 'with valid user and event tokens' do
    before { @opts = {event_token: @event.signup_token,
                      user_token: @user.signup_token,
                      scout_id: @scout.id,
                      scouts_attending: 1,
                      siblings_attending: 1,
                      adults_attending: 1
                     }
            }
    subject { page }

    context 'event signup has not passed' do
      context 'options selected from email' do
        context 'with valid options' do
          before { visit event_email_event_signups_path(@event, @opts) }
          it { should have_text("Signup successful") }
        end

        context 'with invalid options' do
          before { visit event_email_event_signups_path(@event, @opts.merge({scouts_attending: 0, siblings_attending: 0, adults_attending: 0})) }
          it { should have_text("Signup failed")}
          it { should have_text("at least one person must attend")}
        end
      end

      context 'with custom option selected from email' do
        context 'without existing signup' do
          before { visit event_email_event_signups_path(@event, with_custom_options) }
          it { should have_text("Signup for #{@scout.first_name}")}
        end

        context 'with existing signup' do
          before do
            existing_signup
            visit event_email_event_signups_path(@event, with_custom_options)
          end
          it { should have_text("Change signup for #{@scout.first_name}") }
        end
      end

    end



    context 'event signup has passed' do

      before { @event.update_attribute(:signup_deadline, 1.day.ago) }
      context 'with existing signup' do
        before { existing_signup }
        context 'options selected from email' do
          before { visit event_email_event_signups_path(@event, @opts) }
          it { should have_text("Signup changed") }
        end

        context 'with custom options selected from email' do
          before { visit event_email_event_signups_path(@event, with_custom_options) }
          it { should have_text("The deadline for signup has passed, but you can change your existing signup") }
        end
      end

      context 'without existing signup' do
        context 'options selected from email' do
          before { visit event_email_event_signups_path(@event, @opts) }
          it { should have_text("The deadline for signup has passed.") }
        end

        context 'with custom options selected from email' do
          before { visit event_email_event_signups_path(@event, with_custom_options) }
          it { should have_text("The deadline for signup has passed.") }
        end

      end

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
