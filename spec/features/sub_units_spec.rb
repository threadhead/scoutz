require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Sub Units' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!
    create_cub_scout_unit
    @scout3 = FactoryGirl.create(:scout, first_name: 'Marvin', last_name: 'West', sub_unit: @sub_unit2)
    @user.scouts << @scout3
    @scout3.units << @unit
  end

  before(:each) do
    Warden.test_reset!
  end

  context 'as an admin user' do
    before { login_as(@user, scope: :user) }

    context 'when viewing a list of unit sub units' do
      before { visit unit_sub_units_path(@unit) }

      it 'has a new sub unit button' do
        expect(page).to have_link('New Den')
      end
      it 'shows the sub unit name' do
        expect(page).to have_link('Den 44')
        expect(page).to have_link('Den 55')
      end

      it 'shows the count of scouts in sub unit' do
        expect(find('tr', text: 'Den 44')).to have_css('.badge', text: '1')
        expect(find('tr', text: 'Den 55')).to have_css('.badge', text: '2')
      end

      it 'shows the names of the scouts in a sub unit' do
        expect(find('tr', text: 'Den 44')).to have_text(@scout1.name)
        expect(find('tr', text: 'Den 44')).not_to have_text(@scout2.name)
        expect(find('tr', text: 'Den 44')).not_to have_text(@scout3.name)

        expect(find('tr', text: 'Den 55')).to have_text(@scout2.name)
        expect(find('tr', text: 'Den 55')).to have_text(@scout3.name)
        expect(find('tr', text: 'Den 55')).not_to have_text(@scout1.name)
      end
    end

    context 'when adding a new sub unit' do
      before { visit new_unit_sub_unit_path(@unit) }

      context 'with valid data' do
        before do
          within 'form.new_sub_unit' do
            fill_in 'Name', with: 'Den 777'
            fill_in 'Description', with: 'The best den evah!'
          end
        end

        it 'displays the form' do
          expect(page).to have_text('New Den in Cub Scout Pack 134')
          expect(page).to have_selector('form')
          expect(page).to have_selector('input#sub_unit_name')
          expect(page).to have_selector('input#sub_unit_description')
        end

        it 'enter creats sub unit and displays show page' do
          click_button 'Create Sub unit'

          new_sub_unit = SubUnit.where(name: 'Den 777').first
          expect(new_sub_unit).not_to be_nil
          expect(page.current_path).to eq(unit_sub_unit_path(@unit, new_sub_unit))
          expect(page).to have_text('Den: Den 777')
        end

      end

      context 'with invalid data' do
        it 'displays message with errors' do
          click_button 'Create Sub unit'

          expect(page).to have_text('Name can\'t be blank')
        end

        it 'with existing name, displays error message, retuns to form' do
          within 'form.new_sub_unit' do
            fill_in 'Name', with: 'Den 44'
          end
          click_button 'Create Sub unit'

          expect(page.current_path).to eq(unit_sub_units_path(@unit))
          expect(page).to have_content('Name has already been taken')
        end
      end

      context 'clicking cancel' do
        it 'clicking cancel takes you back to the sub unit list' do
          click_link 'Cancel'

          expect(page).to have_link('Den 55')
        end
      end
    end



    context 'when showing a sub unit' do
      before { visit unit_sub_unit_path(@unit, @sub_unit2) }

      it 'has the sub unit name' do
        expect(page).to have_text("Den: Den 55")
      end

      it 'shows that this sub unit can not be destroyed' do
        expect(page).not_to have_link('Destroy Den 55')
        expect(page).to have_content('You can not destroy this Den.')
      end

      it 'has links to all scouts in sub unit' do
        expect(page).to have_link(@scout2.name_lf)
        expect(page).to have_link(@scout3.name_lf)
        expect(page).not_to have_link(@scout1.name_lf)
      end

      it 'clicking a scouts name takes you to their show page' do
        click_link @scout2.name_lf

        expect(page.current_path).to eq(unit_scout_path(@unit, @scout2))
        expect(page).to have_text("Scout: #{@scout2.name}")
      end

      it 'clicking the edit button goes to the edit page' do
        click_link 'Edit'

        expect(page).to have_text('Edit Den')
        expect(page).to have_selector('form')
        expect(page).to have_selector('input#sub_unit_name')
        expect(page).to have_selector('input#sub_unit_description')
      end
    end



    context 'deleting sub unit' do
      before do
        @sub_unit3 = FactoryGirl.create(:sub_unit, name: 'Den 54321', unit: @unit)
        visit unit_sub_unit_path(@unit, @sub_unit3)
      end

      it 'deletes the user and returns to the adult list' do
        click_link 'Destroy Den 54321'

        expect(page.current_path).to eq(unit_sub_units_path(@unit))
        expect(page).to have_text('was successfully destroyed')
        expect(page).to_not have_link('Den 54321')
      end
    end



    context 'editing an adult' do
      before { visit edit_unit_sub_unit_path(@unit, @sub_unit2) }

      it 'displays the edit form' do
        expect(page).to have_text('Edit Den')
        expect(page).to have_selector('form')
        expect(page).to have_selector('input#sub_unit_name')
        expect(page).to have_selector('input#sub_unit_description')
      end

      it 'has a cancel button' do
        expect(page).to have_link('Cancel')
      end

      it 'has a submit button' do
        expect(page).to have_button('Update Sub unit')
      end

      describe 'changing the name' do
        before do
          within "form.edit_sub_unit" do
            fill_in 'Name', with: 'Den 999'
          end
        end

        it 'saves the new name' do
          click_button 'Update Sub unit'

          expect(page.current_path).to eq(unit_sub_unit_path(@unit, @sub_unit2))
          expect(page).to have_text('Den: Den 999')
          expect(page).to have_content('successfully updated')
        end

        it 'clicking Cancel takes you back to the show page' do
          click_link 'Cancel'

          expect(page.current_path).to eq(unit_sub_unit_path(@unit, @sub_unit2))
          expect(page).to have_text('Den: Den 55')
        end
      end
    end
  end
end
