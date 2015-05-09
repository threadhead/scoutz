require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Health form viewing and roles' do
  before(:all) do
    Capybara.default_driver = :rack_test
    Warden.test_mode!
    create_boy_scout_unit
    @admin_user = @user
    @admin_user_form = FactoryGirl.create(:health_form_empty, user: @admin_user, unit: @unit, philmont_date: Date.today)
    @admin_scout = @scout1
    FactoryGirl.create(:health_form_empty, user: @admin_scout, unit: @unit, summit_tier_date: Date.today)

    @basic_user = FactoryGirl.create(:adult, role: 'basic')
    FactoryGirl.create(:health_form_empty, user: @basic_user, unit: @unit, part_a_date: Date.today, part_b_date: Date.today)
    @basic_user.units << @unit
    @basic_scout = FactoryGirl.create(:scout, sub_unit: @sub_unit1)
    @basic_user.scouts << @basic_scout
    @basic_scout.units << @unit
    FactoryGirl.create(:health_form_empty, user: @basic_scout, unit: @unit, part_c_date: Date.today)

    @tag_scout = @scout2
  end

  before(:each) do
    Warden.test_reset!
  end


  context 'As an admin user' do
    before { login_as(@admin_user, scope: :user) }

    let(:form) { FactoryGirl.create(:health_form_empty, user: @tag_scout, unit: @unit) }
    let(:tags) { %w(A B C P S FSB N) }

    describe 'displays the proper tags' do
      { part_a_date: 'A', part_b_date: 'B', part_c_date: 'C', summit_tier_date: 'S', florida_sea_base_date: 'FSB', northern_tier_date: 'NT', philmont_date: 'P' }.each do |k, v|
        context "when a user has #{k}" do
          before do
            form.update_attribute(k, Date.today)
            visit unit_scout_path(@unit, @tag_scout)
          end

          it "displays #{v} in a label" do
            expect(page).to have_css('div.label', count: 1)
            expect(page).to have_css('div.label', text: /\A#{v}\z/)
          end

          it 'does not display other tags' do
            (tags - [v]).each do |tag|
              expect(page).not_to have_css('div.label', text: /\A#{tag}\z/)
            end
          end

          it 'displays a green tag when form expires > 30 days' do
            expect(page).to have_css('div.label.label-success', text: /\A#{v}\z/)
          end

          it 'displays a red tag when form expires' do
            form.update_attribute(k, Date.today - 1.year)
            visit unit_scout_path(@unit, @tag_scout)
            expect(page).to have_css('div.label.label-danger', text: /\A#{v}\z/)
          end

          it 'displays a red tag when form expires < 30 days' do
            form.update_attribute(k, Date.today - 360.days)
            visit unit_scout_path(@unit, @tag_scout)
            expect(page).to have_css('div.label.label-warning', text: /\A#{v}\z/)
          end
        end
      end


      context 'displays "none on file"' do
        it 'when users has no health form record' do
          visit unit_scout_path(@unit, @tag_scout)
          expect(page).to have_content('none on file')
        end

        it 'when user has a health form record, but all forms are blank' do
          form # triggers creation of empty health form
          visit unit_scout_path(@unit, @tag_scout)
          expect(page).to have_content('none on file')
        end
      end
    end

    describe 'can see health form tags' do
      it 'for thier user record' do
        visit unit_adult_path(@unit, @admin_user)
        expect(page).to have_content('Health Forms')
        expect(page).to have_selector('div.label', text: 'P')
      end

      it 'for adult in unit record' do
        visit unit_adult_path(@unit, @basic_user)
        expect(page).to have_content('Health Forms')
        expect(page).to have_selector('div.label', text: 'A')
        expect(page).to have_selector('div.label', text: 'B')
      end

      it 'for their scouts record' do
        visit unit_scout_path(@unit, @admin_scout)
        expect(page).to have_content('Health Forms')
        expect(page).to have_selector('div.label', text: 'S')
      end

      it 'for other scouts record' do
        visit unit_scout_path(@unit, @basic_scout)
        expect(page).to have_content('Health Forms')
        expect(page).to have_selector('div.label', text: 'C')
      end
    end
  end


  context 'As a basic user' do
    before { login_as(@basic_user, scope: :user) }

    describe 'can see health form tags' do
      it 'for their user record' do
        visit unit_adult_path(@unit, @basic_user)
        expect(page).to have_content('Health Forms')
        expect(page).to have_selector('div.label', text: 'A')
        expect(page).to have_selector('div.label', text: 'B')
      end

      it 'for their scouts record' do
        visit unit_scout_path(@unit, @basic_scout)
        expect(page).to have_content('Health Forms')
        expect(page).to have_css('div.label', text: 'C')
      end
    end

    describe 'can not see health form tags' do
      it 'for adults other than themselves' do
        visit unit_adult_path(@unit, @admin_user)
        expect(page).to_not have_content('Health Forms')
        expect(page).to_not have_selector('div.label', text: 'P')
        expect(page).to_not have_selector('div.label', text: 'A')
      end

      it 'for adults other than themselves' do
        visit unit_scout_path(@unit, @admin_scout)
        expect(page).to_not have_content('Health Forms')
        expect(page).to_not have_selector('div.label', text: 'S')
        expect(page).to_not have_selector('div.label', text: 'A')
      end
    end
  end
end
