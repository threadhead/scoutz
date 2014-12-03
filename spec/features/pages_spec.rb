require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Pages' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
    @page = FactoryGirl.create(:page, unit: @unit)
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before{ login_as(@user, scope: :user) }


    context 'when viewing a list of pages' do
      before{ visit unit_pages_path(@unit) }

      it 'shows the page list' do
        expect(page.current_path).to eq(unit_pages_path(@unit))
      end
    end



    context 'adding a new page' do
      before { visit new_unit_page_path(@unit) }

      it 'displays the form page' do
        expect(page.current_path).to eq(new_unit_page_path(@unit))
        expect(page).to have_text('New Page for Cub Scout Pack 134')
      end
    end



    context 'when showing an existing page' do
      before{ visit unit_page_path(@unit, @page) }

      it 'displays the page show page' do
        expect(page.current_path).to eq(unit_page_path(@unit, @page))
      end
    end



    # context 'deleting an event' do
    #   before do
    #     @del_page = FactoryGirl.create(:event, unit: @unit)
    #     visit unit_event_path(@unit, @del_page)
    #   end

    #   it 'deletes the event and returns to the event list' do
    #     click_link "Destroy Event"

    #     expect(Event.exists?(id: @del_page.id)).to eq(false)
    #     expect(page.current_path).to eq(unit_events_path(@unit))
    #   end
    # end



    context 'editing a page' do
      before do
        @del_page = FactoryGirl.create(:page, unit: @unit)
        visit unit_page_path(@unit, @del_page)

        click_link "edit" # this only works because there is only 1 page
      end

      after{ @del_page.destroy }

      it 'displays the edit form page' do
        expect(page.current_path).to eq(edit_unit_page_path(@unit, @del_page))
        expect(page).to have_text("Edit Page")
      end
    end

  end
end
