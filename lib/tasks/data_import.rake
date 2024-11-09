require 'csv'

namespace :data_import do
  desc "Identify cities, inspection types, and violations"
  task analyze_csv: :environment do
    string_converter = lambda { |field, _| field ? field.strip : nil }

    cities = Set.new
    owner_cities = Set.new
    phone_number = Set.new
    phone_number_lengths = Set.new
    inspection_types = Set.new
    violation_types = Set.new
    risk_categories = Set.new
    descriptions = Set.new
    violation_risk_description_types = Hash.new { |h, k| h[k] = Set.new }

    log = nil

    CSV.foreach(Rails.root.join('lib', 'sf_restaurants.csv'), headers: true, converters: [string_converter]) do |r|
      phone_number.add(r['phone_number'])
      phone_number_lengths.add(r['phone_number']&.length)
      cities.add(r['city'])
      owner_cities.add(r['owner_city'])
      inspection_types.add(r['inspection_type'])
      violation_types.add(r['violation_type'])
      # vr.add([r['violation_type'], r['risk_category']])
      violation_risk_description_types[r['violation_type']].add([r['risk_category'], r['description']])
      log = "violation types can have multiple risk categories & descriptions" if violation_risk_description_types[r['violation_type']].length > 1
      
      risk_categories.add(r['risk_category'])
      descriptions.add(r['description'])
    end

    pp "City Types (#{cities.length}):"
    pp cities
    pp "Owner City Types (#{owner_cities.length}):"
    pp owner_cities
    pp "phone number lengths"
    pp phone_number_lengths
    pp "Inspection Types (#{inspection_types.length}):"
    pp inspection_types
    p "Violation type count:"
    pp violation_types.length
    p "violation type count = description type count?"
    pp violation_types.length == descriptions.length
    p "Risk Category count:"
    pp risk_categories.length
    pp log ? log : "a violation type only has exactly 1 associated risk category & description"
  end
end
