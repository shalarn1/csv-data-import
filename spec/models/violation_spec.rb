# == Schema Information
#
# Table name: violations
#
#  id                :bigint           not null, primary key
#  occurred_on       :date             not null
#  violation_type_id :bigint           not null
#  inspection_id     :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Violation, type: :model do
	describe 'validations' do
		describe 'presence' do
			it { should validate_presence_of :occurred_on }
		end

		describe 'association' do
      it { should belong_to :inspection }
      it { should belong_to :violation_type }
    end
	end
end
