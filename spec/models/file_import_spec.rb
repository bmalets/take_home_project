# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileImport, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:trade_lines).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:trade_lines) }
    it { is_expected.to have_one_attached(:document) }
  end

  describe 'Validations' do
    subject(:file_import) { build(:file_import) }

    it { is_expected.to validate_presence_of(:status) }

    it { is_expected.to validate_content_type_of(:document).allowing('application/json') }
    it { is_expected.to validate_size_of(:document).less_than(100.megabytes) }
  end
end
