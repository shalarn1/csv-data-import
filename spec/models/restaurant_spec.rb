require 'rails_helper'

RSpec.describe Restaurant, type: :model do
	describe 'validations' do
		describe 'presence' do
			it { should validate_presence_of :name }
		end

		# describe 'uniqueness' do
		# 	before { create :restaurant }
		# 	it { should validate_uniqueness_of(:name).scoped_to(:address_id) }
		# end

		describe 'association' do
      it { should belong_to :address }
      it { should belong_to :owner }
    end
  end
end