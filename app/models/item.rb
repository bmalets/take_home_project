# frozen_string_literal: true

class Item < ApplicationRecord
  include AASM

  belongs_to :trade_line
  belongs_to :file_import, optional: true

  belongs_to :bureau

  validates :status, presence: true

  aasm column: :status do
    state :unspecified, initial: true
    state :negative
    state :disputed

    event :analyzed_as_negative do
      transitions from: :unspecified, to: :negative
    end

    event :analyzed_as_disputed do
      transitions from: :unspecified, to: :disputed
    end

    event :mark_as_disputed do
      transitions from: :negative, to: :disputed
    end

    event :undo_mark_as_disputed do
      transitions from: :disputed, to: :negative
    end
  end

  def could_mark_as_disputed?
    return true if negative?

    # changed to disputed state manually (not initially)
    disputed? && (created_at != updated_at)
  end
end
