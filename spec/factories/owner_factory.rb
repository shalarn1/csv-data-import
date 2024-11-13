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
FactoryBot.define do
  factory :owner do
    name { SecureRandom.hex }
    address
  end
end
