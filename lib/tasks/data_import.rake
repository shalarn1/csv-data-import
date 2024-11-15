require 'csv'

namespace :data_import do
  desc "Import csv data into db"
  task import_data: :environment do
    p "Beginning processing. This may take awhile..."
    entry_count = 0
    CSV.foreach(Rails.root.join('lib', 'sf_restaurants.csv'), headers: true,
                                                              converters: [Normalizer::STRING_CONVERTER]) do |r|
      entry_count += 1
      p "Processed #{entry_count} entries..." if entry_count % 1000 == 0

      ### Normalize fields
      Normalizer.normalize_row(r)

      ### Find or create new violation_type
      violation_type = ViolationType.find_or_create_by(class_code: r['violation_type'],
                                                       risk: r['risk_category'],
                                                       description: r['description'])

      ### Find or create restaurant address & owner address
      normalized_owner_address = Address.normalize_street(r['owner_address'])

      restaurant_address = Address.find_or_initialize_by(street: r['address'],
                                                         postal_code: r['postal_code'])
      if restaurant_address.id.nil?
        restaurant_address.city = r['city']
        restaurant_address.state = 'CA' # since all restaurants are in SF. Determine from zipcode if using an address validator API
        restaurant_address.save!
      end

      ## Find or create owner & owner address
      if r['owner_name']
        if r['owner_address'] == r['address']
          address = restaurant_address # since restaurant address data was cleaner than owner address data
        elsif r['owner_address']
          address = Address.find_or_initialize_by(street: r['owner_address'],
                                                  postal_code: r['owner_zip'])
          if address.id.nil?
            address.city = r['owner_city']
            address.state = r['owner_state']
            address.save!
          end
        end
        owner = Owner.find_or_create_by!(name: r['owner_name'], address: address)
      end

      ### Find or create restaurants
      restaurant = Restaurant.find_or_initialize_by(name: r['name'], address: restaurant_address)
      if restaurant.id.nil?
        restaurant.phone_number = r['phone_number']
        restaurant.owner = owner if owner
        restaurant.save!
      end

      ### Find or create inspections & violations
      inspection = restaurant.inspections.find_or_initialize_by(occurred_on: r['inspection_date'],
                                                                category: r['inspection_type'])
      inspection.score = r['inspection_score']
      inspection.save!

      inspection.violations.create!(violation_type: violation_type)
    end
  end
end
