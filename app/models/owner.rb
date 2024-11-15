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
end
