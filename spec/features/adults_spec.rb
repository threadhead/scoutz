require 'spec_helper'

describe 'Adults' do
  before(:all) { Capybara.default_driver = :rack_test }

  before(:all) do
    create_cub_scout_unit
  end

  context 'when viewing a list of unit adults' do
    before do
      sign_in_user(@user.email, 'sekritsekrit')
      click_link 'Adults'
    end

    it 'shows the adult name, den, leadership position, and scouts' do
      within '#content table' do
        expect(page).to have_link('Karl, Tara')
        expect(page).to have_text('Den 44, Den 55')
        expect(page).to have_text('Committee Chair')
        expect(page).to have_link("Bocephus Jones")
        expect(page).to have_link("Aydan Russel")
      end
    end
  end
end
