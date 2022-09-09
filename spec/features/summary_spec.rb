require 'rails_helper'

RSpec.describe 'Disabled trade line items', type: :feature do
  let(:file_import) { create(:file_import) }
  let(:expected_table_cells_data) do
    %w[Unspecified 0 3 0 Disputed 3 0 0 Negative 0 0 3]
  end
  let(:expected_table_tfoot_data) do
    %w[Total 3 3 3]
  end
  let(:trade_lines) { create_list(:trade_line, 3, file_import:, raw:) }

  let(:raw) do
    {
      equifax_data: {
        comments: Faker::Lorem.sentence,
        account_type: Faker::Lorem.word,
        account_type_detail: Faker::Lorem.sentence,
        payment_status: Faker::Lorem.word,
        payment_history: { Faker::Date.backward.to_s => 'OK' }
      },
      experian_data: {
        comments: 'dispute',
        account_type: Faker::Lorem.word,
        account_type_detail: Faker::Lorem.sentence,
        payment_status: Faker::Lorem.word,
        payment_history: { Faker::Date.backward.to_s => 'OK' }
      },
      transunion_data: {
        comments: 'collection',
        account_type: Faker::Lorem.word,
        account_type_detail: Faker::Lorem.sentence,
        payment_status: Faker::Lorem.word,
        payment_history: { Faker::Date.backward.to_s => 'OK' }
      }
    }
  end

  let(:equifax_bureau) { create(:bureau, name: 'Equifax') }
  let(:experian_bureau) { create(:bureau, name: 'Experian') }
  let(:trans_union_bureau) { create(:bureau, name: 'TransUnion') }

  before do
    trade_lines.each do |trade_line|
      create(:item, trade_line:, bureau: experian_bureau)
      create(:item, :disputed, trade_line:, bureau: equifax_bureau)
      create(:item, :negative, trade_line:, bureau: trans_union_bureau)
    end
  end

  it 'shows correct summary values by bureau' do
    visit file_import_summary_path(file_import)

    table_cells_data = page.all('td').map(&:text)
    expect(table_cells_data).to eq(expected_table_cells_data)
  end

  it 'shows correct total summary values by statuses' do
    visit file_import_summary_path(file_import)

    table_tfoot_data = page.find('tfoot').all('th').map(&:text)
    expect(table_tfoot_data).to eq(expected_table_tfoot_data)
  end
end
