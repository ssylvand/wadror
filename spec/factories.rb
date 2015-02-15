FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :style do
    style "Weizen"
    description "Great beer"
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer_club do
    name "anonymous"
    founded 1900
    city "Espoo"
  end
end