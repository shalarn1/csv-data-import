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
class Inspection < ApplicationRecord
	validates :occurred_on, :category, presence: true
	validates_uniqueness_of :occurred_on, scope: [:restaurant_id, :category]
	enum category: %i[routine_unscheduled routine_scheduled reinspection_follow_up
										foodborne_illness_investigation non_inspection_site_visit complaint new_ownership]

	belongs_to :restaurant
end
