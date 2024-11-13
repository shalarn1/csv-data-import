# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  street      :string           not null
#  city        :string           not null
#  state       :string           not null
#  postal_code :string           not null
#  country     :string           default("US")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Address, type: :model do
	describe 'validations' do
		describe 'presence' do
			it { should validate_presence_of :street }
			it { should validate_presence_of :city }
			it { should validate_presence_of :state }
			it { should validate_presence_of :postal_code }
		end

		describe 'uniqueness' do
			before { create :address }
			it { should validate_uniqueness_of(:street).scoped_to(:postal_code) }
		end

		describe 'association' do
      it { should have_many :restaurants }
      it { should have_many :owners }
    end
	end

	# describe '#normalize_city' do
	# 	let(:address) { create :address }
	# 	[
	# 		[["San Francisco", "S.F.", "SAN FRANCISCO", "SF", "SAN FANCISCO", "san francisco"], 'San Francisco'],
	# 		[["SO.S.F.", "South San Francisco", "So. S.F."], "South San Francisco"],
	# 		[["Okland"], 'Oakland'],
	# 		[["DALY CITY", "Daly City"], "Daly City"],
	# 		[["Millvalley"], "Mill Valley"],
	# 		[["SAN RAFAEL", "San Rafael"], 'San Rafael']
	# 	].each do |city_names, result|
	# 		city_names.each do |city|
	# 	    context "when city is #{city}" do
	# 	      it 'normalizes to the right city name' do
	# 	        address.city = city
	# 	        address.save!
	# 	        expect(address.reload.city).to eq(result)
	# 	      end
	# 	    end
	# 	  end
  #   end

  #   ["BERKELEY", "WASHINGTON", "Menlo Park", "SEATTLE", "MILLBRAE", "Mountain View", "BRISBANE", "KNOXVILLE", 
  #    "KENWOOD", "EMERYVILLE", "GREENVILLE", "ROSEMEAD", "Richmond", "Seattle", "Larkspur", "MURRAY", "Brea", 
  #    "ANTIOCH", "PACIFICA", "DANVILLE"].each do |city|
	# 	    context "when city is #{city}" do
	# 	      it 'titleizes the city' do
	# 	        address.city = city
	# 	        address.save!
	# 	        expect(address.city).to eq(city.titleize)
	# 	      end
	# 	    end
	# 	  end

  #   context 'when city is nil' do
  #     it 'stays nil' do
  #       address.city = nil
  #       address.save!
  #       expect(address.reload.city).to be_nil
  #     end
  #   end
  # end

  # TODO add spec for ::/#normalize_postal_code
end
