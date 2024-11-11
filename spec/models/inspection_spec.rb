# == Schema Information
#
# Table name: inspections
#
#  id            :bigint           not null, primary key
#  score         :integer
#  occurred_on   :date             not null
#  category      :integer          not null
#  restaurant_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Inspection, type: :model do
		describe 'validations' do
		it { should define_enum_for :category }

		describe 'presence' do
			it { should validate_presence_of :occurred_on }
			it { should validate_presence_of :category }
		end

		# describe 'uniqueness' do
		# 	before { create :inspection }
		# 	it { should validate_uniqueness_of(:occurred_on).scoped_to([:restaurant_id, :category]) }
		# end

		describe 'association' do
      it { should belong_to :restaurant }
    end
	end
end
