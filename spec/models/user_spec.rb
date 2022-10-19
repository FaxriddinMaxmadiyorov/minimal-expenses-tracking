require 'rails_helper'

RSpec.describe User, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.allow_blank }
  end

  context 'Associations' do
    it 'has_many expenses' do
      association = described_class.reflect_on_association(:expenses)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end
end
