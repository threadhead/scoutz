require 'spec_helper'
include Warden::Test::Helpers

RSpec.describe 'Adults' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    Warden.test_mode!

    create_cub_scout_unit
  end

  before(:each) do
    # Warden.test_reset!
    login_as(@user, scope: :user)
    visit unit_adults_path(@unit)
  end

  context 'when viewing a list of unit adults' do
    it 'shows the adult name, den, leadership position, and scouts' do
      within 'body .container-fluid table' do
        expect(page).to have_link('Karl, Tara')
        # expect(page).to have_text('Den 44, Den 55') -- we no longer display related patrols
        expect(page).to have_text('Committee Chair')
        expect(page).to have_link("Bocephus Jones")
        expect(page).to have_link("Aydan Russel")
      end
    end
  end

  context 'when adding a new adult' do
    before { click_link 'new adult' }

    context 'with valid data' do
      before do
        within 'form#new_adult' do
          fill_in 'adult_first_name', with: 'Rusty'
          fill_in 'adult_last_name', with: 'Balls'
        end
      end

      it 'enter new adult info, submit, goto to adult show and display show adult page' do
        expect(page).to have_text('New Adult in Cub Scout Pack 134')

        within 'form#new_adult' do
          fill_in 'Email', with: 'rusty.balls@aol.com'
          select 'Webmaster', from: 'Leadership position'
          fill_in 'adult_additional_leadership_positions', with: 'Joker'
          select '1955', from: 'adult_birth_1i'
          select 'February', from: 'adult_birth_2i'
          select '14', from: 'adult_birth_3i'
          fill_in 'Address1', with: '3660 N Lake Shore Dr'
          fill_in 'adult_city', with: 'Chicago'
          fill_in 'adult_state', with: 'IL'
          fill_in 'adult_zip_code', with: '60657'
          # this should be tested later with javascript
          select 'Russel, Aydan', from: 'adult_scout_ids'
        end

        click_button 'Create Adult'

        rusty_balls = User.find_by_first_name('Rusty')
        expect(page.current_path).to eq(unit_adult_path(@unit, rusty_balls))
        expect(page).to have_text('Rusty Balls was successfully created')
        expect(page).to have_text('Adult: Rusty Balls')
        expect(page).to have_text('Cub Scout Pack 134')
        expect(page).to have_text('rusty.balls@aol.com')
        expect(page).to have_text('Webmaster, Joker')
        expect(page).to have_text('3660 N Lake Shore Dr')
        expect(page).to have_text('Chicago, IL 60657')
        expect(page).to have_link('Aydan Russel')
      end

      it 'allows the adult to have multiple related scouts' do
        within 'form#new_adult' do
          select 'Russel, Aydan', from: 'adult_scout_ids'
          select 'Jones, Bocephus', from: 'adult_scout_ids'
        end

        click_button 'Create Adult'

        expect(page).to have_text('Rusty Balls was successfully created')
        expect(page).to have_link('Aydan Russel')
        expect(page).to have_link('Bocephus Jones')
      end

      it 'allows an adult to have no related scouts' do
        click_button 'Create Adult'

        expect(page).to have_text('Rusty Balls was successfully created')
        expect(page).to_not have_link('Aydan Russel')
        expect(page).to_not have_link('Bocephus Jones')
      end
    end

    context 'with invalid data' do
      it 'displays flash messages with errors' do
        click_button 'Create Adult'

        expect(page).to have_text('First name can\'t be blank')
        expect(page).to have_text('Last name can\'t be blank')
      end

      it 'entered data is persisted' do
        within 'form#new_adult' do
          fill_in 'adult_last_name', with: 'Eustus'
        end

        click_button 'Create Adult'

        expect(page).to have_text('First name can\'t be blank')
        expect(page).to have_field('adult_last_name', with: 'Eustus')
      end
    end

    context 'clicking cancel' do
      it 'returns to adult list' do
        click_link 'Cancel'

        expect(page.current_path).to eq(unit_adults_path(@unit))
      end
    end
  end



  context 'when showing an existing adult' do
    before do
      click_link 'Karl, Tara'
    end

    it 'clicking the name of the users goes to the edit view' do
      expect(page.current_path).to eq(unit_adult_path(@unit, @user))
      expect(page).to have_text('Adult: Tara Karl')
    end

    it 'clicking unit_name adults returns to adult list' do
      click_link 'Pack 134 adults'

      expect(page).to have_text('Adults in Pack 134')
      expect(page.current_path).to eq(unit_adults_path(@unit))
    end

    it 'clicking change edits the adult' do
      click_link 'change'

      expect(page).to have_text('Edit Adult')
      expect(page.current_path).to eq(edit_unit_adult_path(@unit, @user))
    end
  end



  context 'deleting an adult' do
    before do
      @user2 = FactoryGirl.create(:adult, first_name: 'Bonnie', last_name: 'Doom')
      @user2.units << @unit
      visit unit_adult_path(@unit, @user2)
    end

    it 'deletes the user and returns to the adult list' do
      click_link 'destroy Bonnie'

      expect(page.current_path).to eq(unit_adults_path(@unit))
      expect(page).to have_text('Bonnie Doom, and all associated data, was permanently deleted')
      expect(page).to_not have_text('Doom, Bonnie')
    end
  end



  context 'editing an adult' do
    before do
      @user2 = FactoryGirl.create(:adult, first_name: 'Bonnie', last_name: 'Doom')
      @user2.units << @unit
      visit unit_adult_path(@unit, @user2)
      click_link 'change'

      within "form#edit_adult_#{@user2.id}" do
        fill_in 'adult_first_name', with: 'Fionula'
        fill_in 'adult_additional_leadership_positions', with: 'Jester'
      end
    end

    after do
      @user2.destroy
    end

    it 'updates fields when changed and returns to the show page' do
      click_button 'Update Adult'

      expect(page.current_path).to eq(unit_adult_path(@unit, @user2))
      expect(page).to have_text('Fionula Doom was successfully updated')
      expect(page).to have_text('Fionula Doom')
      expect(page).to_not have_text('Bonnie Doom')
      expect(page).to have_text('Jester')
    end

    it 'canceling update does not change data and returns to show page' do
      click_link 'Cancel'

      expect(page.current_path).to eq(unit_adult_path(@unit, @user2))
      expect(page).to have_text('Bonnie Doom')
      expect(page).to_not have_text('Fionula Doom')
    end
  end

end
