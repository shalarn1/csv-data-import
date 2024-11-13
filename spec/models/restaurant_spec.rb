# == Schema Information
#
# Table name: restaurants
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  phone_number :string(15)
#  address_id   :bigint           not null
#  owner_id     :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Restaurant, type: :model do
	describe 'validations' do
		describe 'presence' do
			it { should validate_presence_of :name }
		end

		describe 'uniqueness' do
			before { create :restaurant }
			it { should validate_uniqueness_of(:name).scoped_to(:address_id) }
		end

		describe 'association' do
      it { should belong_to :address }
      it { should belong_to(:owner).optional }
      it { should have_many :inspections }
      it { should have_many :violations }
    end
  end
end
