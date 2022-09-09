# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TradeLine, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:file_import) }
    it { is_expected.to have_many(:items) }
  end

  describe 'Validations' do
    subject(:trade_line) { build(:trade_line) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:raw) }
  end
end
