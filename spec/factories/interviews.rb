FactoryBot.define do
  factory :interview do
    user_invitation
    status{Interview.statuses.values.sample}
    evaluate{Faker::Lorem.paragraph}
  end
end
