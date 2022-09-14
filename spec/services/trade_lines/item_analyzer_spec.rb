# frozen_string_literal: true

require 'rails_helper'

describe TradeLines::ItemAnalyzer, type: :service do
  subject(:service) { described_class.new(trade_line:) }

  let(:trade_line) { create(:trade_line, raw:) }
  let(:raw) { { equifax_data: bureau_data } }

  before { create(:bureau, name: 'Equifax') }

  describe '#call' do
    let(:item) { trade_line.items.first }

    before { service.call }

    context 'when correct data' do
      let(:bureau_data) do
        {
          comments: Faker::Lorem.sentence,
          account_type: Faker::Lorem.word,
          account_type_detail: Faker::Lorem.sentence,
          payment_status: Faker::Lorem.word,
          payment_history: { Faker::Date.backward.to_s => 'OK' }
        }
      end
      let(:expected_status) { 'unspecified' }

      it 'creates unspecified item' do
        expect(item.status).to eq(expected_status)
      end
    end

    context 'when dispute keyword in comments' do
      let(:bureau_data) do
        {
          comments: 'disPUte',
          account_type: Faker::Lorem.word,
          account_type_detail: Faker::Lorem.sentence,
          payment_status: Faker::Lorem.word,
          payment_history: { Faker::Date.backward.to_s => 'OK' }
        }
      end
      let(:expected_status) { 'disputed' }

      it 'creates disputed item' do
        expect(item.status).to eq(expected_status)
      end
    end

    context 'when dispute and collection keywords present' do
      let(:bureau_data) do
        {
          comments: 'disPUte coLLection',
          account_type: Faker::Lorem.word,
          account_type_detail: Faker::Lorem.sentence,
          payment_status: Faker::Lorem.word,
          payment_history: { Faker::Date.backward.to_s => 'OK' }
        }
      end
      let(:expected_status) { 'disputed' }

      it 'creates disputed item' do
        expect(item.status).to eq(expected_status)
      end
    end

    context 'when empty payment history item' do
      let(:bureau_data) do
        {
          comments: Faker::Lorem.sentence,
          account_type: Faker::Lorem.word,
          account_type_detail: Faker::Lorem.sentence,
          payment_status: Faker::Lorem.word,
          payment_history: { Faker::Date.backward.to_s => '' }
        }
      end
      let(:expected_status) { 'unspecified' }

      it 'creates unspecified item' do
        expect(item.status).to eq(expected_status)
      end
    end

    context 'when invalid payment history item' do
      let(:bureau_data) do
        {
          comments: Faker::Lorem.sentence,
          account_type: Faker::Lorem.word,
          account_type_detail: Faker::Lorem.sentence,
          payment_status: Faker::Lorem.word,
          payment_history: { Faker::Date.backward.to_s => 'INVALID' }
        }
      end
      let(:expected_status) { 'negative' }

      it 'creates negative item' do
        expect(item.status).to eq(expected_status)
      end
    end

    context 'when collection keyword' do
      context 'with collection keyword in comments' do
        let(:bureau_data) do
          {
            comments: 'coLLecTIon',
            account_type: Faker::Lorem.word,
            account_type_detail: Faker::Lorem.sentence,
            payment_status: Faker::Lorem.word,
            payment_history: { Faker::Date.backward.to_s => 'OK' }
          }
        end
        let(:expected_status) { 'negative' }

        it 'creates negative item' do
          expect(item.status).to eq(expected_status)
        end
      end

      context 'with collection keyword in account_type' do
        let(:bureau_data) do
          {
            comments: Faker::Lorem.sentence,
            account_type: 'coLLecTIon',
            account_type_detail: Faker::Lorem.sentence,
            payment_status: Faker::Lorem.word,
            payment_history: { Faker::Date.backward.to_s => 'OK' }
          }
        end
        let(:expected_status) { 'negative' }

        it 'creates negative item' do
          expect(item.status).to eq(expected_status)
        end
      end

      context 'with collection keyword in account_type_detail' do
        let(:bureau_data) do
          {
            comments: Faker::Lorem.sentence,
            account_type: Faker::Lorem.word,
            account_type_detail: 'coLLecTIon',
            payment_status: Faker::Lorem.word,
            payment_history: { Faker::Date.backward.to_s => 'OK' }
          }
        end
        let(:expected_status) { 'negative' }

        it 'creates negative item' do
          expect(item.status).to eq(expected_status)
        end
      end

      context 'with collection keyword in payment_status' do
        let(:bureau_data) do
          {
            comments: Faker::Lorem.sentence,
            account_type: Faker::Lorem.word,
            account_type_detail: Faker::Lorem.sentence,
            payment_status: 'coLLecTIon',
            payment_history: { Faker::Date.backward.to_s => 'OK' }
          }
        end
        let(:expected_status) { 'negative' }

        it 'creates negative item' do
          expect(item.status).to eq(expected_status)
        end
      end
    end
  end
end
