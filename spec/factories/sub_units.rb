FactoryGirl.define do

  sequence :sub_unit_name_cubs do |n|
    "Den #{n+1}"
  end

  sequence :sub_unit_name_boys do |n|
  	"Patrol #{n+1}"
  end

  factory :sub_unit do
		name			{ FactoryGirl.generate(:sub_unit_name_cubs) }

    factory :cub_scout_sub_unit do
      name      { FactoryGirl.generate(:sub_unit_name_cubs) }
    end

    factory :boy_scout_sub_unit do
      name      { FactoryGirl.generate(:sub_unit_name_boys) }
    end
	end
end
