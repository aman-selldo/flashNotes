FactoryBot.define do
  factory :answer do
    association :question
    answer {"answer"}
  end
end
