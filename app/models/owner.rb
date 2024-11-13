# == Schema Information
#
# Table name: owners
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  address_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Owner < ApplicationRecord
	validates :name, presence: true
	validates_uniqueness_of :name, scope: [:address_id]

	belongs_to :address, optional: true
	has_many :restaurants

	def self.normalize_name(name)
		case name
		when 'STARBUCKS COFFEE COMPANY', 'STARBUCKS COFFEE CO.', 'STARBUCKS CORP', 'Starbucks Coffee Company', 'Starbucks Coffee Co', 'STARBUCKS COFFEE CORP', 'Starbucks Corporation'
			'Starbucks Coffee Company'
		when 'PANDA EXPRESS, INC.', 'PANDA EXPRESS CO., INC.'
			'Panda Express, Inc.'
		when "Andre-Boudin Bakeries, Inc", "Andre Boudin Bakery, Inc."
			"Andre Boudin Bakery, Inc."
		when "PRACHIMA, INC", "PRACHIMA, INC."
			"Prachima, Inc."
		when "Peet's Coffee", "Peet's Coffee and Tea", "Peets Coffee & Tea, Inc"
			"Peets Coffee & Tea, Inc."
		when "SAN FRANCISCO SOUP CO. LLC", "San Francisco Soup Company LLC"
			"San Francisco Soup Company LLC"
		when "The Ritz-Carlton Hotel Co", "The Ritz-Carlton Hotel Company."
			"The Ritz-Carlton Hotel Company"
		else
			name&.strip&.downcase
		end
	end
end
