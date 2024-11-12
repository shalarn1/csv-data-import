# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  street      :string           not null
#  city        :string
#  state       :string
#  postal_code :string           not null
#  country     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Address < ApplicationRecord
	validates :street, :postal_code, presence: true
	validates :street, uniqueness: { scope: [:postal_code] }

	has_many :restaurants
	has_many :owners

	def self.normalize_city(city)
		case city
		when "San Francisco", "S.F.", "SAN FRANCISCO", "SF", "SAN FANCISCO", "san francisco"
			"San Francisco"
		when "SO.S.F.", "South San Francisco", "So. S.F."
			"South San Francisco"
		when "Okland"
			"Oakland"
		when "Millvalley"
			"Mill Valley"
		else
			city&.titleize
		end
	end

	def self.normalize_postal_code(postal_code, city: nil)
		case postal_code
		when "9411"
		 	"94110"
		when nil
		 	if city&.upcase == "SAN RAFAEL"
		 		"94903"
		 	elsif city&.upcase == "ANTIOCH"
		 		"94509"
		 	end
		else
			postal_code
		end
	end
end
