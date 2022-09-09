# frozen_string_literal: true

require 'rails_helper'

describe 'File imports', type: :request do
  describe 'GET /' do
    it 'responds with success' do
      get root_path
      expect(response.code).to eq('200')
    end

    it 'renders index template' do
      get root_path
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE /file_imports/:id' do
    let!(:file_import) { create(:file_import) }

    it 'responds with redirect' do
      delete file_import_path(file_import)
      expect(response.code).to eq('303')
    end

    it 'redirects to index' do
      delete file_import_path(file_import)
      expect(response).to redirect_to(root_path)
    end

    it 'deletes record' do
      expect { delete file_import_path(file_import) }
        .to change(FileImport, :count).by(-1)
    end
  end
end
