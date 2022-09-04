class TradeLine < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :raw, presence: true
end
