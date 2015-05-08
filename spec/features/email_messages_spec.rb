require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Email Messages' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
    @email_message = FactoryGirl.create(:email_message, unit: @unit)
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before { login_as(@user, scope: :user) }


    context 'when viewing a list of email messages' do
      before { visit unit_email_messages_path(@unit) }

      it 'shows the event list' do
        expect(page.current_path).to eq(unit_email_messages_path(@unit))
      end
    end



    context 'adding a new email message' do
      before { visit new_unit_email_message_path(@unit) }

      it 'displays the form page' do
        expect(page.current_path).to eq(new_unit_email_message_path(@unit))
        expect(page).to have_text('New Email for Cub Scout Pack 134')
      end
    end



    context 'when showing an existing email message' do
      before { visit unit_email_message_path(@unit, @email_message) }

      it 'displays the email message show page' do
        expect(page.current_path).to eq(unit_email_message_path(@unit, @email_message))
      end
    end



    # context 'deleting an event' do
    #   before do
    #     @del_event = FactoryGirl.create(:event, unit: @unit)
    #     visit unit_event_path(@unit, @del_event)
    #   end

    #   it 'deletes the event and returns to the event list' do
    #     click_link "Destroy Event"

    #     expect(Event.exists?(id: @del_event.id)).to eq(false)
    #     expect(page.current_path).to eq(unit_events_path(@unit))
    #   end
    # end



    # context 'editing an event' do
    #   before do
    #     @del_event = FactoryGirl.create(:event, unit: @unit)
    #     visit unit_event_path(@unit, @del_event)

    #     click_link "Edit"
    #   end

    #   after{ @del_event.destroy }

    #   it 'displays the edit form page' do
    #     expect(page.current_path).to eq(edit_unit_event_path(@unit, @del_event))
    #     expect(page).to have_text("Edit Event")
    #   end
    # end

  end
end
