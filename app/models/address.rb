# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  street      :string           not null
#  city        :string           not null
#  state       :string
#  postal_code :string           not null
#  country     :string           default("US")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Address < ApplicationRecord
  validates :street, :city, :postal_code, presence: true
  validates :street, uniqueness: { scope: [:postal_code] }
  # TODO validate state and country stored as ISO codes

  has_many :restaurants
  has_many :owners
end
