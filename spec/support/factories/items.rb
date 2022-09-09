# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    bureau
    trade_line

    status { Faker::Lorem.word }

    trait :negative do
      status { :negative }
    end

    trait :disputed do
      status { :disputed }
    end
  end
end
