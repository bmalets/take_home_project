module TradeLines
  class Analyzer
    BUREAU_KEYS = {
      'Experian' => 'experian_data',
      'Equifax' => 'equifax_data',
      'TransUnion' => 'transunion_data'
    }.freeze

    def initialize(trade_line:)
      @trade_line = trade_line
      @raw_data = @trade_line.raw
    end

    def call
      return if @trade_line.items.any?

      Bureau.find_each do |bureau|
        item = @trade_line.items.create(bureau_id: bureau.id)
        analyze_item(item, bureau)
      end
    end

    private

    def analyze_item(item, bureau)
      bureau_key  = BUREAU_KEYS[bureau.name]
      bureau_data = @raw_data[bureau_key]

      item.analyzed_as_negative! if negative?(bureau_data)
      item.analyzed_as_disputed! if dispute?(bureau_data)
    end

    def negative?(bureau_data)
      payment_history = bureau_data.dig('payment_history')
      return true if payment_history.is_a?(Hash) && payment_history.values.without("OK", "").any?

      bureau_data
        .slice("comments", "account_type", "account_type_details", "payment_status")
        .values
        .any? { |attribute| attribute.is_a?(String) && attribute.include?("collection") }
    end

    def dispute?(bureau_data)
      comments = bureau_data['comments']
      comments.is_a?(String) && comments.include?("dispute")
    end
  end
end