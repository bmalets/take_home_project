# frozen_string_literal: true

require 'rails_helper'

describe 'Summary', type: :request do
  let(:bureau) { create(:bureau) }
  let(:file_import) { create(:file_import) }
  let(:trade_line) { create(:trade_line, file_import:) }

  before do
    create_list(:item, 3, trade_line:, bureau:)
  end

  describe 'GET /file_imports/:id/summary' do
    it 'responds with success' do
      get file_import_summary_path(file_import)
      expect(response.code).to eq('200')
    end

    it 'renders index template' do
      get file_import_summary_path(file_import)
      expect(response).to render_template(:show)
    end
  end
end
