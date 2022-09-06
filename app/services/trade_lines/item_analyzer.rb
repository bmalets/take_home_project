# frozen_string_literal: true

module TradeLines
  class ItemAnalyzer
    BUREAU_KEYS = {
      'Experian' => 'experian_data',
      'Equifax' => 'equifax_data',
      'TransUnion' => 'transunion_data'
    }.freeze

    COMMENTS_ATTRIBUTE = 'comments'
    PAYMENT_HISTORY_ATTRIBUTE = 'payment_history'

    VALID_PAYMENT_HISTORY_VALUE = 'OK'

    COLLECTION_ATTRIBUTES = [
      COMMENTS_ATTRIBUTE,
      'account_type',
      'account_type_details',
      'payment_status'
    ].freeze

    DISPUTE_KEY = 'dispute'
    COLLECTION_KEY = 'collection'

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

      # Dispute takes precedence,
      # we don’t wont to dispute stuff that is already being disputed.
      if dispute?(bureau_data)
        item.analyzed_as_disputed!
        return
      end

      item.analyzed_as_negative! if negative?(bureau_data)
    end

    def negative?(bureau_data)
      bad_payment_history?(bureau_data) || with_collection?(bureau_data)
    end

    def dispute?(bureau_data)
      comments = bureau_data[COMMENTS_ATTRIBUTE]
      return false unless comments

      comments.downcase.include?(DISPUTE_KEY)
    end

    def bad_payment_history?(bureau_data)
      payment_history = bureau_data[PAYMENT_HISTORY_ATTRIBUTE]
      return false unless payment_history

      payment_history
        .values
        .any? { |value| value != VALID_PAYMENT_HISTORY_VALUE }
    end

    def with_collection?(bureau_data)
      bureau_data
        .slice(*COLLECTION_ATTRIBUTES)
        .values
        .any? { |value| value.downcase.include?(COLLECTION_KEY) }
    end
  end
end
