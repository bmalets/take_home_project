# frozen_string_literal: true

FactoryBot.define do
  factory :file_import do
    status { :pending }

    trait :failed do
      status { :failed }
    end

    trait :success do
      status { :success }
    end
  end
end
