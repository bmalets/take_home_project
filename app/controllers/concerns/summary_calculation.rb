# frozen_string_literal: true

module SummaryCalculation
  extend ActiveSupport::Concern

  def summary_data(bureaus, items)
    bureaus.map do |bureau|
      {
        bureau_name: bureau.name,
        unspecified: items.count { |item| item.bureau_id == bureau.id && item.unspecified? },
        disputed: items.count { |item| item.bureau_id == bureau.id && item.disputed? },
        negative: items.count { |item| item.bureau_id == bureau.id && item.negative? }
      }
    end
  end
end
