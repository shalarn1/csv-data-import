# == Schema Information
#
# Table name: owners
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  address_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
      it { should belong_to(:address).optional }
      it { should have_many :restaurants }
    end
	end

	# TODO ::normalize_name spec
end
