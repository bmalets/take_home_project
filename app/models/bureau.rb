# frozen_string_literal: true

class Bureau < ApplicationRecord
  has_many :items, dependent: :restrict_with_exception

  validates :name, uniqueness: true, presence: true
end
