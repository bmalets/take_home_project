class TradeLine < ApplicationRecord
  belongs_to :file_import
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :raw, presence: true
end
