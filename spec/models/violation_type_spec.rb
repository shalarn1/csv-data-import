require 'rails_helper'

RSpec.describe ViolationType, type: :model do
	describe 'validations' do
		it { should define_enum_for :risk_category }

		describe 'presence' do
			it { should validate_presence_of :classification_code }
			it { should validate_presence_of :risk_category }
			it { should validate_presence_of :description }
		end

		describe 'uniqueness' do
			before { create :violation_type }
			it { should validate_uniqueness_of :classification_code }
		end
  end

  describe '::normalize_risk_category' do
  	let(:low_risk) { 'Low Risk' }
  	let(:moderate_risk) { 'Moderate Risk'}
  	let(:high_risk) { 'High Risk'}
  	let(:invalid_risk) { SecureRandom.hex }

    it 'normalizes risk category to the right enum' do
      expect(ViolationType.normalize_risk_category(low_risk)).to eq(:low)
      expect(ViolationType.normalize_risk_category(moderate_risk)).to eq(:medium)
      expect(ViolationType.normalize_risk_category(high_risk)).to eq(:high)
      expect(ViolationType.normalize_risk_category(invalid_risk)).to be_nil
    end
	end
end