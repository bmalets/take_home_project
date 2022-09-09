require 'rails_helper'

RSpec.describe 'Disabled trade line items', type: :feature do
  let(:file_import) { create(:file_import) }
  let(:trade_line) { create(:trade_line, file_import:, raw:) }

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
    create(:item, trade_line:, bureau: experian_bureau)
    create(:item, :disputed, trade_line:, bureau: equifax_bureau)
    create(:item, :negative, trade_line:, bureau: trans_union_bureau)
  end

  it 'is not possible to mark as disputed initially unspecified item' do
    visit file_import_trade_lines_path(file_import)
    checkboxes = page.all('input[type="checkbox"]').to_a

    unspecified_checkbox = checkboxes.first
    expect(unspecified_checkbox.disabled?).to be(true)
  end

  it 'is not possible to mark as disputed initially disputed item' do
    visit file_import_trade_lines_path(file_import)
    checkboxes = page.all('input[type="checkbox"]').to_a

    negative_checkbox = checkboxes.third
    expect(negative_checkbox.disabled?).to be(false)
  end

  it 'is possible to mark as disputed initially negative item' do
    visit file_import_trade_lines_path(file_import)
    checkboxes = page.all('input[type="checkbox"]').to_a

    negative_checkbox = checkboxes.third
    expect(negative_checkbox.disabled?).to be(false)
  end
end
