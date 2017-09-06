FactoryBot.define do
  factory :user do
    email{"#{SecureRandom.alphanumeric(12)}@sample.com"}
  end
end
