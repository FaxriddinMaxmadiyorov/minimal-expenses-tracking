require 'rails_helper'

RSpec.describe Expense, type: :model do

  context 'validation' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:category_id) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
  end

  let(:expense) { build(:expense) }

  it 'amount should be equal 99' do
    expect(expense.amount).to be 99
  end
end
