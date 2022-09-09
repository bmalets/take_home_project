# frozen_string_literal: true

require 'rails_helper'

describe Bureau, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:items).dependent(:restrict_with_exception) }
  end

  describe 'Validations' do
    subject(:bureau) { build(:bureau) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'Scopes' do
    describe 'default' do
      let!(:bureau_b) { create(:bureau, name: 'bureau_b') }
      let!(:bureau_a) { create(:bureau, name: 'bureau_a') }

      it 'sorts records by name asc' do
        expect(described_class.all).to eq([bureau_a, bureau_b])
      end
    end
  end
end
