require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'User health forms' do

  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
    create_boy_scout_unit
  end

  before(:each) do
    Warden.test_reset!
    login_as(@user, scope: :user)
  end

  # context 'Creating a new user' do
  #   context 'tells the user they can edit after they save' do
  #     it 'for new Adults' do
  #       visit new_unit_adult_path(@unit)
  #       expect(page).to have_content('edit health forms after the user is saved')
  #     end
  #     it 'for new Scouts' do
  #       visit new_unit_scout_path(@unit)
  #       expect(page).to have_content('edit health forms after the user is saved')
  #     end
  #   end
  # end

  context 'As an admin user' do
    context 'an adult users show page' do
      def set_hidden_fields_form_date
        find(:xpath, "//input[@id='health_form_part_a_date']").set "2015-11-01"
        find(:xpath, "//input[@id='health_form_part_b_date']").set "2015-11-02"
        find(:xpath, "//input[@id='health_form_part_c_date']").set "2015-11-03"
        find(:xpath, "//input[@id='health_form_northern_tier_date']").set "2015-11-04"
        find(:xpath, "//input[@id='health_form_summit_tier_date']").set "2015-11-05"
        find(:xpath, "//input[@id='health_form_philmont_date']").set "2015-11-06"
        find(:xpath, "//input[@id='health_form_florida_sea_base_date']").set "2015-11-07"
      end

      def confirm_form_date_changes
        health_form = @user.health_forms.unit(@unit)
        expect(health_form).to_not be_nil

        expect(health_form.part_a_date).to eq(Date.parse '2015-11-01')
        expect(health_form.part_b_date).to eq(Date.parse '2015-11-02')
        expect(health_form.part_c_date).to eq(Date.parse '2015-11-03')
        expect(health_form.northern_tier_date).to eq(Date.parse '2015-11-04')
        expect(health_form.summit_tier_date).to eq(Date.parse '2015-11-05')
        expect(health_form.philmont_date).to eq(Date.parse '2015-11-06')
        expect(health_form.florida_sea_base_date).to eq(Date.parse '2015-11-07')
      end


      describe 'when user has no health forms, click Add' do
        before do
          visit unit_adult_url(@unit, @user)
          within '#user-info' do
            click_link 'Add'
          end
        end

        it 'clicking cancel returns to users edit page' do
          click_link 'Cancel'
          expect(page).to have_content('Adult:')
        end

        it 'clicking submit returns to users edit page' do
          click_button 'Create Health form'
          expect(page).to have_content('Adult:')
        end

        it 'creates a new health form for the user' do
          set_hidden_fields_form_date
          click_button 'Create Health form'

          confirm_form_date_changes
        end
      end

      describe 'when health form exists, click Edit' do
        before do
          HealthForm.create(user: @user, unit: @unit,
                            part_a_date: '2015-10-01',
                            part_b_date: '2015-10-02',
                            part_c_date: '2015-10-03',
                            northern_tier_date: '2015-10-04',
                            summit_tier_date: '2015-10-05',
                            philmont_date: '2015-10-06',
                            florida_sea_base_date: '2015-10-07'
                            )
          visit unit_adult_url(@unit, @user)
          within '#user-info' do
            click_link 'Edit'
          end
        end

        it 'clicking cancel returns to users edit page' do
          click_link 'Cancel'
          expect(page).to have_content('Adult:')
        end

        it 'clicking submit returns to users edit page' do
          click_button 'Update Health form'
          expect(page).to have_content('Adult:')
        end

        it 'edits the existing health form and saves changes' do
          set_hidden_fields_form_date
          click_button 'Update Health form'

          confirm_form_date_changes
        end
      end


    end
  end
end
