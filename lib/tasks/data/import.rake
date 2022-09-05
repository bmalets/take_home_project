# frozen_string_literal: true

namespace :data do
  desc 'import file with trade lines'
  task :import, [:file_path] => :environment do |_, args|
    file_name = args[:file_path]&.strip
    abort 'Please provide an argument' if file_name.blank?

    file_path = Rails.root.join(file_name)
    abort 'File does not exist' unless File.exist?(file_path)

    file_import = TradeLines::Importer.new(file_path:).call
    TradeLines::Analyzer.new(file_import:).call
  end
end
