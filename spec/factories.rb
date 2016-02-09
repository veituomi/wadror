FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end
  
  factory :user2, class: User do
    username "Harrastelija"
    password "Foobar2"
    password_confirmation "Foobar2"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end
  
  factory :brewery do
    name "Koff"
    year 1900
  end
  
  factory :brewery2, class: Brewery do
    name "Olvi"
    year 1899
  end

  factory :beer do
    name "Lager olut"
    brewery
    style "Lager"
  end
  
  factory :beer_ipa, class: Beer do
    name "IPA olut"
    brewery
    style "IPA"
  end
end