FactoryBot.define do
  factory :restaurant do
    name { SecureRandom.hex }
    owner
    address
  end
end
