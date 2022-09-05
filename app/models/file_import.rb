class FileImport < ApplicationRecord
  has_many :trade_lines, dependent: :destroy

  has_one_attached :document, dependent: :purge
end
