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
class Violation < ApplicationRecord
  validates :occurred_on, presence: true
  # TODO validate occurred_on is the same value as inspection.occurred_on

  belongs_to :inspection
  belongs_to :violation_type
end
