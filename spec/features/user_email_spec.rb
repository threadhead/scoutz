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
    @user1.confirm
    @user1.units << @unit
    @user2 = FactoryGirl.create(:adult)
    @user2_orig_email = @user2.email
    @user2.units << @unit
    @user2.confirm

    login_as(@user1, scope: :user)
  end

  context 'user changing thier own email' do
    before { visit edit_unit_user_email_path(@unit, @user1) }


    it 'shows the user current email address' do
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
        expect(ActionMailer::Base.deliveries.first.body).to have_content('Confirm my email change to: joe.smith@aol.com')
      end

      it 'does not send an email to the user\'s old email address' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to).not_to eq([@user2_orig_email])
      end

    end
  end




  describe 'changing anthother user\'s email address' do
    context 'as admin user' do
      before do
        @user1.update_attribute(:role, 'admin')
        visit edit_unit_user_email_path(@unit, @user2)
      end

      it 'displayes the Change password form' do
        expect(page).to have_content("Change #{@user2.name.possessive} Email")
      end

      describe 'can change email' do
        before do
          within 'form.edit_adult' do
            fill_in 'New Email', with: 'putty@aol.com'
            click_button 'Update Email'
          end
        end

        it 'sends an email to the users new email address' do
          expect(ActionMailer::Base.deliveries.size).to eq(1)
          expect(ActionMailer::Base.deliveries.first.to).to eq(['putty@aol.com'])
        end

        it 'returns to the users show page' do
          expect(page).to have_content('putty@aol.com')
          expect(page).to have_content("Adult: #{@user2.name}")
        end
      end
    end



    context 'as leader user' do
      it 'can change their own email' do
        visit edit_unit_adult_path(@unit, @user1)
        expect(page).to have_css('#change_user_email')
      end

      it 'can not change other user\'s email' do
        visit edit_unit_adult_path(@unit, @user2)
        expect(page).not_to have_link('#change_user_email')
      end

      it 'can edit their scout\'s email' do
        scout = FactoryGirl.create(:scout)
        scout.units << @unit
        @user1.scouts << scout
        visit edit_unit_scout_path(@unit, scout)
        expect(page).to have_css('#change_user_email')
      end

      it 'can not edit other scout\'s email' do
        scout = FactoryGirl.create(:scout)
        scout.units << @unit
        @user2.scouts << scout
        visit edit_unit_scout_path(@unit, scout)
        expect(page).not_to have_css('#change_user_email')
      end
    end
  end

end
