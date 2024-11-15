# == Schema Information
#
# Table name: violation_types
#
#  id          :bigint           not null, primary key
#  class_code  :integer          not null
#  risk        :integer          not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe ViolationType, type: :model do
  describe 'validations' do
    it { should define_enum_for :risk }

    describe 'presence' do
      it { should validate_presence_of :class_code }
      it { should validate_presence_of :risk }
      it { should validate_presence_of :description }
    end

    describe 'uniqueness' do
      before { create :violation_type }
      it { should validate_uniqueness_of :class_code }
    end

    describe 'association' do
      it { should	have_many :violations }
      it { should have_many :inspections }
    end
  end
end
