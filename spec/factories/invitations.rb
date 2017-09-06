FactoryBot.define do
  factory :invitation do
    candidate
    interview_date{Time.current + 2.days}
    room{Faker::Team.name}
    used_alias{}
    alias_name{''}
    division{Invitation.divisions.values.sample}
    position{Invitation.positions.values.sample}
    user_list{[FactoryBot.create(:user).id]}
  end
end
