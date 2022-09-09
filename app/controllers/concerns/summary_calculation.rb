# frozen_string_literal: true

module SummaryCalculation
  extend ActiveSupport::Concern

  def summary_data(bureaus, items)
    bureaus.map do |bureau|
      {
        name: bureau.name,
        unspecified: items.count { |item| item.bureau_id == bureau.id && item.unspecified? },
        disputed: items.count { |item| item.bureau_id == bureau.id && item.disputed? },
        negative: items.count { |item| item.bureau_id == bureau.id && item.negative? }
      }
    end
  end

  def total(summary_data)
    data = {}

    summary_data.map do |bureau_info|
      name = bureau_info[:name]
      total = bureau_info[:unspecified] + bureau_info[:disputed] + bureau_info[:negative]

      data[name] = total
    end

    data
  end
end
