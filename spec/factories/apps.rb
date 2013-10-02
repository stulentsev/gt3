# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :app do
    sequence(:name) {|x| "app #{x}"}
    app_key { SecureRandom.hex }
  end
end
