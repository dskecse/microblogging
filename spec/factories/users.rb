FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{ n }" }
    sequence(:email) { |n| "person_#{ n }@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    factory :admin do
      admin true
    end

    trait :with_microposts do
      after(:build) do |user|
        create_list(:micropost, 3, user: user)
      end
    end
  end
end
