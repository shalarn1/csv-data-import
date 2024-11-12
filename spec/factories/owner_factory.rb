FactoryBot.define do
  factory :owner do
    name { SecureRandom.hex }
    address
  end
end
