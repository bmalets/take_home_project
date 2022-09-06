# frozen_string_literal: true

class FileImportsController < ApplicationController
  def index
    @file_imports = FileImport.all
  end
end
