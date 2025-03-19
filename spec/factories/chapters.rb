FactoryBot.define do
  factory :chapter do
    name { "reproduction" }
    association :subject
  end
end