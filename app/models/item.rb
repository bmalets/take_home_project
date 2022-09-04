class Item < ApplicationRecord
  include AASM

  belongs_to :trade_line
  belongs_to :bureau

  validates :status, presence: true

  aasm column: :status do
    state :unspecified, initial: true
    state :negative
    state :disputed

    event :dispute do
      transitions from: :negative, to: :disputed
    end
  end
end
