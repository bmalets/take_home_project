# frozen_string_literal: true

FactoryBot.define do
  factory :trade_line do
    file_import

    name { Faker::Lorem.word }
    raw { Faker::Json.shallow_json(width: 3) }
  end
end
