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
class ViolationType < ApplicationRecord
  validates :class_code, :risk, :description, presence: true
  validates :class_code, uniqueness: true

  enum risk: %i[low medium high]

  has_many :violations
  has_many :inspections, through: :violations

  def self.normalize_risk(risk)
    case risk
    when /^low/i
      :low
    when /^moderate/i
      :medium
    when /^high/i
      :high
    end
  end
end
