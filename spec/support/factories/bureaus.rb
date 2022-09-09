# frozen_string_literal: true

FactoryBot.define do
  factory :bureau do
    name { Faker::Company.name }
  end
end
