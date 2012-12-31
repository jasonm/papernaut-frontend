FactoryGirl.define do
  factory :user do
  end

  factory :import do
    user
    state 'running'
  end
end
