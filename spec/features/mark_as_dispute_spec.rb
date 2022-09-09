require 'rails_helper'

RSpec.describe 'Disabled trade line items', type: :feature, js: true do
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

    allow_any_instance_of(ActionController::Base).to receive(:protect_against_forgery?).and_return(true)

    visit file_import_trade_lines_path(file_import)
  end

  context 'when marks as disputed negative item' do
    let(:negative_checkbox) { page.all('input[type="checkbox"]').to_a.last }
    let(:negative_label) { page.all('label').to_a.last }

    before { negative_checkbox.click }

    it 'changes the status to Disputed' do
      expect(negative_label.text).to eq('Disputed')
    end

    context 'when reload page' do
      let(:reloaded_checkbox) { page.all('input[type="checkbox"]').to_a.last }
      let(:reloaded_label) { page.all('label').to_a.last }

      before { visit file_import_trade_lines_path(file_import) }

      it 'shows the new status' do
        expect(reloaded_label.text).to eq('Disputed')
      end

      it 'shows the checkbox as checked' do
        expect(reloaded_checkbox.checked?).to be true
      end
    end

    context 'when marks disputed item back to negative' do
      before { negative_checkbox.click }

      it 'changes the status back to Negative' do
        expect(negative_label.text).to eq('Negative')
      end

      context 'when reload page' do
        let(:reloaded_checkbox) { page.all('input[type="checkbox"]').to_a.last }
        let(:reloaded_label) { page.all('label').to_a.last }

        before { visit file_import_trade_lines_path(file_import) }

        it 'shows the new status' do
          expect(reloaded_label.text).to eq('Negative')
        end

        it 'shows the checkbox as unchecked' do
          expect(reloaded_checkbox.checked?).to be false
        end
      end
    end
  end
end
