# == Schema Information
#
# Table name: violation_types
#
#  id          :bigint           not null, primary key
#  class_code  :integer          not null
#  risk        :integer          not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :violation_type do
    sequence(:class_code) { |n| n }
    risk { [:low, :medium, :high].sample }
    description { SecureRandom.hex }
  end
end
