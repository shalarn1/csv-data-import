require 'csv'

namespace :analysis do
  desc "Identify possible values and relationships"
  task analyze_csv: :environment do
    p "Beginning processing. Analyzing csv..."
    # data stores for inspection & violation types
    inspection_types = Set.new
    inspection_scores = Set.new
    inspections = Set.new
    violation_types = Set.new
    risk_categories = Set.new
    descriptions = Set.new

    violation_risk_description_types = Hash.new { |h, k| h[k] = Set.new }
    vt_log = "a violation type has exactly 1 associated risk category & description"

    # data stores for restaurant & owner info
    restaurant_names = Set.new
    owners = Set.new
    restaurant_addresses = Set.new
    owner_addresses = Set.new
    cities = Set.new
    owner_cities = Set.new
    r_zip_codes = Set.new
    o_zip_codes = Set.new
    phone_numbers = Set.new
    phone_number_lengths = Set.new
    owner_full_addresses = Set.new

    restaurants_to_addresses = Hash.new { |h, k| h[k] = Set.new }
    addresses_to_restaurants = Hash.new { |h, k| h[k] = Set.new }
    owners_to_restaurants = Hash.new { |h, k| h[k] = Set.new }
    owners_to_addresses = Hash.new { |h, k| h[k] = Set.new }
    phone_numbers_to_restaurants = Hash.new { |h, k| h[k] = Set.new }
    restaurants_to_phone_numbers = Hash.new { |h, k| h[k] = Set.new }
    addresses_to_phone_numbers = Hash.new { |h, k| h[k] = Set.new }
    starbucks = Hash.new { |h, k| h[k] = Set.new }

    matching_address = false
    missing = Hash.new(false)

    i_log = "inspection date & violation date are always the same"
    r_log = "a restaurant has exactly 1 associated address and owner"
    a_log = "an address has exactly 1 associate restaurant"
    rp_log = "a restaurant name and address has up to 1 phone number"
    o_log = "owners have exactly 1 restaurant"
    oa_log = "owners have exactly 1 address"

    # analyze data in csv to understand how to design the db
    CSV.foreach(Rails.root.join('lib', 'sf_restaurants.csv'), headers: true, converters: [Normalizer::STRING_CONVERTER]) do |r|
      Normalizer.normalize_row(r)

      # find all possible unique values for inspection types & violation types
      inspection_types.add(r['inspection_type'])
      inspection_scores.add(r['inspection_score'])
      inspections.add([r['name'], r['inspection_date'], r['inspection_type']])
      violation_types.add(r['violation_type'])
      violation_risk_description_types[r['violation_type']].add([r['risk_category'], r['description']])
      i_log = "inspection date & violation date can be different" if r['inspection_date'] != r['violation_date']

      vt_log = "violation types can have multiple risk categories & descriptions" if violation_risk_description_types[r['violation_type']].length > 1

      risk_categories.add(r['risk_category'])
      descriptions.add(r['description'])

      # find all possible unique restaurant names, owner names, restaurant/owner addresses, zip codes, phone numbers
      restaurant_names.add(r['name'])
      owners.add(r['owner_name'])
      restaurant_addresses.add(r['address'])
      owner_addresses.add(r['owner_address'])
      r_zip_codes.add(r['postal_code'])
      o_zip_codes.add(r['owner_zip'])
      cities.add(r['city'])
      owner_cities.add(r['owner_city'])
      phone_numbers.add(r['phone_number'])
      phone_number_lengths.add(r['phone_number']&.length)
      phone_numbers_to_restaurants[r['phone_number']].add([r['name'], r['address']]) if r['phone_number']
      restaurants_to_phone_numbers[r['name']].add([r['phone_number'], r['address'],
                                                   r['owner_name']]) if r['phone_number']
      addresses_to_phone_numbers[r['address']].add(r['phone_number']) if r['phone_number']
      owner_full_addresses.add([r['owner_address'], r['owner_city'], r['owner_zip']]) if r['owner_address']

      # find nonstandard and incomplete address info
      matching_address = true if r['address'] == r['owner_address']

      missing[:restaurant_zipcode] ||= true if r['postal_code'].nil? && r['address'].present?
      missing[:owner] ||= true if r['owner_name'].nil? && r['owner_address'].present?
      missing[:owner_address] ||= true if r['owner_address'].nil? && r['owner_name'].present?
      missing[:owner_zipcode] ||= true if r['owner_zip'].nil? && r['owner_address'].present?
      missing[:owner_city] ||= true if r['owner_city'].nil? && r['owner_address'].present?
      missing[:owner_state] ||= true if r['owner_state'].nil? && r['owner_address'].present?
      missing[:owner_city_zip] ||= true if r['owner_city'].nil? && r['owner_zip'].nil? && r['owner_address'].present?
      missing[:owner_state_zip] ||= true if r['owner_state'].nil? && r['owner_zip'].nil? && r['owner_address'].present?

      # find possilbe relationships between restaurants, locations, owners, and owner addresses
      restaurants_to_addresses[r['name']].add([r['address'], r['owner_name'], r['owner_address'], r['phone_number']])
      addresses_to_restaurants[r['address']].add(r['name'])
      owners_to_restaurants[r['owner_name']].add([r['name'], r['address']])
      owners_to_addresses[r['owner_name']].add(r['owner_address'])
      a_log = "an address can have many restaurants associated with it" if addresses_to_restaurants[r['address']].length > 1
      r_log = "a restaurant can have many addresses and owners" if restaurants_to_addresses[r['name']].length > 1
      o_log = "owners can have many restaurants" if owners_to_restaurants[r['owner_name']].length > 1
      oa_log = "owners can have many addresses" if owners_to_addresses[r['owner_name']].length > 1

      # find all starbucks associations
      if r['name'].match(/^starbucks/i)
        starbucks[r['name']].add([r['address'], r['owner_name'], r['owner_address']])
      end
    end

    # inspect findings
    multiple_addresses_info = "Restaurants w/ multiple locations:\n"
    restaurants_to_addresses.each do |k, v|
      if v.length > 1
        multiple_addresses_info << "#{v.length} locations:\n"
        v.each do |address, owner, o_address, number|
          multiple_addresses_info << "name: #{k}, address: #{address}, owner: #{owner}, owner address:#{o_address}, number: #{number}\n"
        end
        multiple_addresses_info << "------------------------------------------\n"
      end
    end

    phone_info = "\nRestaurants w/ more than 1 phone number (#{restaurants_to_phone_numbers.length}):\n"
    restaurants_to_phone_numbers.each do |k, v|
      if v.length > 1
        phone_info << "name: #{k}\n"
        v.each do |number, address, owner|
          phone_info << "phone number: #{number}, address: #{address}, owner: #{owner}\n"
        end
        phone_info << "------------------------------------------\n"
      end
    end

    starbucks_owners_addresses = Hash.new { |h, k| h[k] = Set.new }
    starbucks_info = "\nStarbucks affiliates (#{starbucks.length}):\n"
    starbucks.each do |k, v|
      starbucks_info << "#{v.length} locations\n"
      v.each do |address, owner, o_address|
        starbucks_owners_addresses[owner].add(o_address)
        starbucks_info << "name: #{k}, address: #{address}, owner: #{owner}, owner address: #{o_address}\n"
      end
      starbucks_info << "------------------------------------------\n"
    end

    starbucks_owner_info = "\nStarbucks owners (#{starbucks_owners_addresses.length}):\n"
    starbucks_owners_addresses.each do |k, v|
      starbucks_owner_info << "owner name: #{k}\n"
      v.each do |address|
        starbucks_owner_info << "owner address: #{address}\n"
      end
      starbucks_owner_info << "------------------------------------------\n"
    end

    zip_codes = r_zip_codes + o_zip_codes
    text = "Restaurant count: #{restaurant_names.length}\n"\
           "Restaurant address count: #{restaurant_addresses.count}\n"\
           "Restaurant address can be blank? #{restaurant_addresses.include? nil}\n"\
           "Restaurant zipcode can be blank? #{r_zip_codes.include? nil}\n"\
           "Restaurant zipcode can be blank when address provided? #{missing[:restaurant_zipcode]}\n"\
           "Restaurant phone number can be blank? #{phone_numbers.include? nil}\n"\
           "Restaurant owner can be blank? #{owners.include? nil}\n\n"\
           "Owner address can be blank? #{owner_addresses.include? nil}\n"\
           "Owner name can be blank when owner address provided? #{missing[:owner]}\n"\
           "Owner address can be blank when owner name provided? #{missing[:owner_address]}\n"\
           "Owner zipcode can be blank when owner address provided? #{missing[:owner_zipcode]}\n"\
           "Owner city can be blank when owner address provided? #{missing[:owner_city]}\n"\
           "Owner state can be blank when owner address provided? #{missing[:owner_state]}\n"\
           "Owner city & zip can be blank when owner address provided? #{missing[:owner_city_zip]}\n\n"\
           "Owner state & zip can be blank when owner address provided? #{missing[:owner_state_zip]}\n\n"\
           "Restaurant & owners can have the same address? #{matching_address}\n"\
           "Restaurants/Addresses/Owners/Phone numbers:\n#{r_log}\n#{a_log}\n#{rp_log}\n"\
           "Owners/Restaurants/Owner Addresses: #{o_log}, #{oa_log}\n\n"\
           "Phone Number Lengths: #{phone_number_lengths}\n\n"\
           "City Types (#{cities.length}): #{cities}\n"\
           "Owner City Types (#{owner_cities.length}):#{owner_cities}\n\n"\
           "Zip codes (#{zip_codes.length}): #{zip_codes}\n"\
           "2 owner zipcodes are missing, 1 owner zipcode is invalid\n\n"\
           "Inspection Types (#{inspection_types.length}):#{inspection_types}\n"\
           "Inspection Count (#{inspections.length})\n"\
           "All inspections have an inspection type? #{!inspection_types.include?(nil)}\n"\
           "Violation Types Count: (#{violation_types.length})\n"\
           "Violation type count = description type count? #{violation_types.length == descriptions.length}\n"\
           "Risk Categories (#{risk_categories.length}):#{risk_categories}\n"\
            "Violation Type Info: #{vt_log}, #{i_log}\n\n"
    File.write(Rails.root.join('log', 'csv_analysis.txt'),
               [text, multiple_addresses_info, starbucks_info, starbucks_owner_info, phone_info].join)
  end
end
