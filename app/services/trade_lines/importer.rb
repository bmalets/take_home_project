# frozen_string_literal: true

module TradeLines
  class Importer
    TRADE_LINE_NAME_ATTRIBUTE = :creditor_furnisher

    def initialize(file_path:)
      @file_path = file_path
    end

    def call
      save_imported_file
      save_trade_lines

      file_import
    end

    private

    def save_imported_file
      file_import.document.attach(
        io: File.open(@file_path),
        filename: @file_path.basename
      )
    end

    def save_trade_lines
      ApplicationRecord.transaction do
        trade_lines_collection.each do |raw_data|
          file_import.trade_lines.create!(
            name: raw_data[TRADE_LINE_NAME_ATTRIBUTE],
            raw: raw_data
          )
        end
      end
    end

    def trade_lines_collection
      @trade_lines_collection ||= FastJsonparser.load(@file_path.to_s)
    end

    def file_import
      @file_import ||= FileImport.create!
    end
  end
end
