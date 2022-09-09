# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:trade_line) }
    it { is_expected.to belong_to(:bureau) }
  end

  describe 'Validations' do
    subject(:item) { build(:item) }

    it { is_expected.to validate_presence_of(:status) }
  end

  describe '#could_mark_as_disputed?' do
    context 'when unspecified' do
      let(:item) { build(:item) }

      it 'returns false' do
        expect(item.could_mark_as_disputed?).to be(false)
      end
    end

    context 'when negative' do
      let(:item) { build(:item, :negative) }

      it 'returns true' do
        expect(item.could_mark_as_disputed?).to be(true)
      end
    end

    context 'when disputed' do
      context 'when initially' do
        let(:item) { build(:item, :disputed) }

        it 'returns false' do
          expect(item.could_mark_as_disputed?).to be(false)
        end
      end

      context 'when manually' do
        let(:item) { build(:item, :disputed, updated_at: Faker::Time.forward) }

        it 'returns true' do
          expect(item.could_mark_as_disputed?).to be(true)
        end
      end
    end
  end
end
