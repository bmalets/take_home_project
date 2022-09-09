# frozen_string_literal: true

require 'rails_helper'

describe 'Trade lines', type: :request do
  let(:item) { create(:item) }

  describe 'PATCH /items/:id' do
    it 'responds with success' do
      patch item_path(item), params: { item: { dispute: true } }
      expect(response.code).to eq('200')
    end
  end
end
