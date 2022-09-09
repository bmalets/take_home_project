# frozen_string_literal: true

require 'rails_helper'

describe TradeLines::Analyzer, type: :service do
  subject(:service) { described_class.new(file_import:) }

  let(:file_import) { create(:file_import) }

  describe '#call' do
    let!(:trade_line) { create(:trade_line, file_import:) }

    let(:item_analyzer) { instance_double(TradeLines::ItemAnalyzer) }

    before do
      allow(TradeLines::ItemAnalyzer).to receive(:new).with(trade_line:).and_return(item_analyzer)
      allow(item_analyzer).to receive(:call)
    end

    it 'calls item analyzer' do
      service.call
      expect(item_analyzer).to have_received(:call)
    end
  end
end
