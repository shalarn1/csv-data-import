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
FactoryBot.define do
  factory :restaurant do
    name { SecureRandom.hex }
    owner
    address
  end
end
