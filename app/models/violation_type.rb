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
class ViolationType < ApplicationRecord
	validates :classification_code, uniqueness: true
	enum risk_category: %i[low moderate high]


	def self.normalize_risk_category(risk_category)
    case risk_category
	  when /^low/i
	  	:low
	  when /^moderate/i
	  	:moderate
	  when /^high/i
	  	 :high
	  end
	end
end
