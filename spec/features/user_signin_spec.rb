require 'spec_helper'

describe 'User signin ablility' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    @user = FactoryGirl.create(:user)
    @np_user = FactoryGirl.create(:user, password: nil)
    @ne_user = FactoryGirl.create(:user, email: nil)
  end

  context 'users with email and password' do
    it 'signs in with correct credentials' do
      sign_in_user(@user.email, 'sekritsekrit')
      page.should have_link('Sign out')
    end

    it 'can\'t sign in with incorrect credentials' do
      sign_in_user(@user.email, 'asdfasdf')
      page.should have_content("Invalid email or password")
    end

    it 'can\'t sign in with incorrect credentials' do
      sign_in_user('', 'sekritsekrit')
      page.should have_content("Invalid email or password")
    end
  end


  context 'users with no email' do
    it 'can not signin' do
      sign_in_user(@ne_user.email, '')
      page.should have_content("Invalid email or password")
    end
  end
end
