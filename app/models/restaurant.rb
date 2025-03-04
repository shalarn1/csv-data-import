# == Schema Information
#
# Table name: restaurants
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  phone_number :string(15)
#  address_id   :bigint           not null
#  owner_id     :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name, scope: [:address_id]
  validates :phone_number, phone: { possible: true }, allow_blank: true

  belongs_to :address
  belongs_to :owner, optional: true

  has_many :inspections
  has_many :violations, through: :inspections
end
