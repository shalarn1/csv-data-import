# == Schema Information
#
# Table name: inspections
#
#  id            :bigint           not null, primary key
#  score         :integer
#  occurred_on   :date             not null
#  category      :integer          not null
#  restaurant_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :inspection do
    occurred_on { 3.days.ago }
    category { :complaint }
    restaurant
  end
end
