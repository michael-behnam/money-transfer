require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { build(:transaction) }

  it 'has a valid factory' do
    expect(transaction).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:receiver) }
    it { is_expected.to validate_presence_of(:amount) }
  end
end
