# frozen_string_literal: true

class FileImportsController < ApplicationController
  before_action :set_file_import, only: %i[show destroy]

  def index
    @file_imports = FileImport.all
  end

  def destroy
    @file_import.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def set_file_import
    @file_import = FileImport.find(params[:id])
  end
end
