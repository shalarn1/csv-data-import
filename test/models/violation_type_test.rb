# == Schema Information
#
# Table name: violation_types
#
#  id                  :bigint           not null, primary key
#  classification_code :integer          not null
#  risk_category       :integer          not null
#  description         :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "test_helper"

class ViolationTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
