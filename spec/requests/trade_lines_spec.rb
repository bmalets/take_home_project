# frozen_string_literal: true

require 'rails_helper'

describe 'Trade lines', type: :request do
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
        comments: Faker::Lorem.sentence,
        account_type: Faker::Lorem.word,
        account_type_detail: Faker::Lorem.sentence,
        payment_status: Faker::Lorem.word,
        payment_history: { Faker::Date.backward.to_s => 'OK' }
      },
      transunion_data: {
        comments: Faker::Lorem.sentence,
        account_type: Faker::Lorem.word,
        account_type_detail: Faker::Lorem.sentence,
        payment_status: Faker::Lorem.word,
        payment_history: { Faker::Date.backward.to_s => 'OK' }
      }
    }
  end

  let(:experian_bureau) { create(:bureau, name: 'Experian') }
  let(:equifax_bureau) { create(:bureau, name: 'Equifax') }
  let(:trans_union_bureau) { create(:bureau, name: 'TransUnion') }

  before do
    create(:item, trade_line:, bureau: experian_bureau)
    create(:item, trade_line:, bureau: equifax_bureau)
    create(:item, trade_line:, bureau: trans_union_bureau)
  end

  describe 'GET /file_imports/:id/trade_lines' do
    it 'responds with success' do
      get file_import_trade_lines_path(file_import)
      expect(response.code).to eq('200')
    end

    it 'renders index template' do
      get file_import_trade_lines_path(file_import)
      expect(response).to render_template(:index)
    end
  end
end
