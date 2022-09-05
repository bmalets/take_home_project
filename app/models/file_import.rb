# frozen_string_literal: true

class FileImport < ApplicationRecord
  include AASM

  has_many :trade_lines, dependent: :destroy
  has_one_attached :document, dependent: :purge

  validates :status, presence: true
  validates :document, content_type: ['application/json'], size: { less_than: 100.megabytes }

  aasm column: :status do
    state :pending, initial: true
    state :failed
    state :success

    event :set_imported do
      transitions from: :pending, to: :success
    end

    event :set_failed do
      transitions from: :pending, to: :failed
    end
  end
end
