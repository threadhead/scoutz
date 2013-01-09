FactoryGirl.define do
  
  sequence :sub_unit_name do |n|
  	"Den #{n+1}"
  end
  
  factory :sub_unit do
		name			{ FactoryGirl.generate(:sub_unit_name) }
	end
end
