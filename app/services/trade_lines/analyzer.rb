module TradeLines
  class Analyzer
    def initialize(file_import:)
      @file_import = file_import
    end

    def call
      @file_import.trade_lines.find_each do |trade_line|
        ItemAnalyzer.new(trade_line: trade_line).call
      end
    end
  end
end
