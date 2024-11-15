# == Schema Information
#
# Table name: violations
#
#  id                :bigint           not null, primary key
#  violation_type_id :bigint           not null
#  inspection_id     :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :violation do
    occurred_on { 3.days.ago }
  end
end
