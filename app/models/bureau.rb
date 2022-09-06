# frozen_string_literal: true

class Bureau < ApplicationRecord
  has_many :items, dependent: :restrict_with_exception

  default_scope { order(name: :asc) }

  validates :name, uniqueness: true, presence: true
end
