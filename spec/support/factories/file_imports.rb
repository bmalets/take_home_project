# frozen_string_literal: true

FactoryBot.define do
  factory :file_import do
    status { Faker::Company.name }
  end
end
