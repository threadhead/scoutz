# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :health_form_expired, class: HealthForm do
    part_a_date            Date.parse('2011-02-02')
    part_b_date            Date.parse('2011-02-02')
    part_c_date            Date.parse('2011-02-02')
    northern_tier_date     Date.parse('2011-02-02')
    philmont_date          Date.parse('2011-02-02')
    florida_sea_base_date  Date.parse('2011-02-02')
    summit_tier_date       Date.parse('2011-02-02')
  end

  factory :health_form do
    part_a_date            Date.today
    part_b_date            Date.today
    part_c_date            Date.today
    northern_tier_date     Date.today
    philmont_date          Date.today
    florida_sea_base_date  Date.today
    summit_tier_date       Date.today
  end

  factory :health_form_empty, class: HealthForm do
    part_a_date            nil
    part_b_date            nil
    part_c_date            nil
    northern_tier_date     nil
    philmont_date          nil
    florida_sea_base_date  nil
    summit_tier_date       nil
  end
end
