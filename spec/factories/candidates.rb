FactoryBot.define do
  factory :candidate do
    name{Faker::Name.name}
    before(:create) do |candidate|
      candidate.candidate_attachments.new FactoryBot.attributes_for(:candidate_attachment)
      candidate.candidate_phones.new FactoryBot.attributes_for(:candidate_phone)
      candidate.candidate_emails.new FactoryBot.attributes_for(:candidate_email)
    end
  end
end
