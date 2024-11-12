require 'rails_helper'

RSpec.describe Owner, type: :model do
	describe 'validations' do
		describe 'presence' do
			it { should validate_presence_of :name }
		end

		describe 'uniqueness' do
			before { create :owner }
			it { should validate_uniqueness_of(:name).scoped_to(:address_id) }
		end

		describe 'association' do
      it { should belong_to :address }
      it { should have_many :restaurants }
    end
	end

	# TODO write normalize_name spec
end