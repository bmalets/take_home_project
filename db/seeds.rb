# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# import bureaus
bureau_names = %w[Experian Equifax TransUnion]
bureau_names.each { |bureau_name| Bureau.find_or_create_by(name: bureau_name) }

# import trade lines
file_name = 'db/data/sample.json'
file_path = Rails.root.join(file_name)
file_import = TradeLines::Importer.new(file_path:).call
TradeLines::Analyzer.new(file_import:).call
