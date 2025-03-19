FactoryBot.define do
  factory :paragraph do
    content { "This is a sample paragraph content." }
    association :chapter
  end
end
