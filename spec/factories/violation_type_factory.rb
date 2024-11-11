FactoryBot.define do
  factory :violation_type do
    sequence(:classification_code) { |n| n }
    risk_category { [:low, :moderate, :high].sample }
    description { SecureRandom.hex }
  end
end
