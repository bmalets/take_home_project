# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemSerializer, type: :serializer do
  describe '#serialize' do
    subject(:serialized_item) { described_class.new(item).serialize }

    context 'when negative' do
      let(:item) { create(:item, :negative) }

      let(:expected_data) do
        {
          item: {
            id: item.id,
            checked: false,
            next_status: 'Negative'
          }
        }.to_json
      end

      it 'serializes item' do
        expect(serialized_item).to eq(expected_data)
      end
    end

    context 'when disputed' do
      let(:item) { create(:item, :disputed) }

      let(:expected_data) do
        {
          item: {
            id: item.id,
            checked: true,
            next_status: 'Disputed'
          }
        }.to_json
      end

      it 'serializes item' do
        expect(serialized_item).to eq(expected_data)
      end
    end
  end
end
