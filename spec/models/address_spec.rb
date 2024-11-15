# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  street      :string           not null
#  city        :string           not null
#  state       :string
#  postal_code :string           not null
#  country     :string           default("US")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of :street }
      it { should validate_presence_of :city }
      it { should validate_presence_of :postal_code }
    end

    describe 'uniqueness' do
      before { create :address }
      it { should validate_uniqueness_of(:street).scoped_to(:postal_code) }
    end

    describe 'association' do
      it { should have_many :restaurants }
      it { should have_many :owners }
    end
  end
end
