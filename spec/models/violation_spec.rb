# == Schema Information
#
# Table name: violations
#
#  id                :bigint           not null, primary key
#  violation_type_id :bigint           not null
#  inspection_id     :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Violation, type: :model do
  describe 'validations' do
    describe 'association' do
      it { should belong_to :inspection }
      it { should belong_to :violation_type }
    end
  end
end
