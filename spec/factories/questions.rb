FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    association :paragraph
  end
end
