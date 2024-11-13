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
FactoryBot.define do
  factory :address do
    street { SecureRandom.hex }
    city { SecureRandom.hex }
    state { SecureRandom.hex }
    postal_code { SecureRandom.hex }
  end
end
