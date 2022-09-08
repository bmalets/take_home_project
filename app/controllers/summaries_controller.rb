# frozen_string_literal: true

class SummariesController < ApplicationController
  include SummaryCalculation

  before_action :set_file_import, only: [:show]

  def show
    bureaus = Bureau.select(:id, :name)
    @data = summary_data(bureaus, @file_import.items)
  end

  private

  def set_file_import
    @file_import = FileImport.find(params[:file_import_id])
  end
end
