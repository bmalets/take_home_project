# frozen_string_literal: true

require 'rails_helper'

describe TradeLines::Importer, type: :service do
  subject(:service) { described_class.new(file_path:) }

  let(:file_path) { Rails.root.join('spec/support/fixtures/test.json') }

  describe '#call' do
    it 'creates a file import' do
      expect { service.call }.to change(FileImport, :count).by(1)
    end

    it 'saves file as attachment' do
      initial_file_name = file_path.basename.to_s
      attachment_file_name = service.call.document.filename.to_s

      expect(initial_file_name).to eq(attachment_file_name)
    end

    it 'imports trade lines' do
      expect { service.call }.to change(TradeLine, :count).by(1)
    end

    it 'returns file import' do
      expect(service.call).to be_a(FileImport)
    end
  end
end
