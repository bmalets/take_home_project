# frozen_string_literal: true

class TradeLinesController < ApplicationController
  before_action :set_file_import, only: [:index]

  def index
    @bureaus = Bureau.select(:id, :name)
    @trade_lines = @file_import.trade_lines.includes(:items)
  end

  private

  def set_file_import
    @file_import = FileImport.find(params[:file_import_id])
  end
end
