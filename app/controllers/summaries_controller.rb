# frozen_string_literal: true

class SummariesController < ApplicationController
  before_action :set_file_import, only: [:show]

  def show
    bureaus = Bureau.select(:id, :name)
    items = @file_import.items

    @data = bureaus.map do |bureau|
      {
        bureau_name: bureau.name,
        unspecified: items.count { |item| item.bureau_id == bureau.id && item.unspecified? },
        disputed: items.count { |item| item.bureau_id == bureau.id && item.disputed? },
        negative: items.count { |item| item.bureau_id == bureau.id && item.negative? }
      }
    end
  end

  private

  def set_file_import
    @file_import = FileImport.find(params[:file_import_id])
  end
end
