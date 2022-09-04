class TradeLinesImporter
  NAME_ATTRIBUTE = :creditor_furnisher

  def initialize(file_path:)
    @file_path = file_path
  end

  def call
    trade_lines = FastJsonparser.load(@file_path.to_s)

    ApplicationRecord.transaction do
      trade_lines.each do |raw_data|
        TradeLine.create!(name: raw_data[NAME_ATTRIBUTE], raw: raw_data)
      end
    end
  end
end
