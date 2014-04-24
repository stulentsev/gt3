# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chart do
    sequence(:name) {|x| "chart #{x}"}
    config 'lines: "0"'
  end
end
