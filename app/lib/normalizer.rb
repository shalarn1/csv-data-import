module Normalizer
  STRING_CONVERTER = lambda { |field, _| field ? field.strip.gsub(/\s+/, ' ') : nil }

  class << self
    def normalize_row(row)
      row.headers.each do |field_name|
        field = row[field_name]
        normalized_field = field&.strip&.gsub(/\s+/, ' ')
        row[field_name] =
          case field_name
          when 'address', 'owner_address'
            normalize_street(normalized_field)
          when 'city', 'owner_city'
            normalize_city(normalized_field)
          when 'postal_code', 'owner_zip'
            if field_name == 'owner_zip' && normalized_field.nil?
              normalize_postal_code(normalized_field, city: row['owner_city'])
            else
              normalize_postal_code(normalized_field)
            end
          when 'phone_number'
            Phonelib.parse(normalized_field).full_e164.presence
          when 'name'
            normalize_restaurant_name(normalized_field)
          when 'owner_name'
            normalize_owner_name(normalized_field)
          when 'inspection_type'
            normalize_inspection_type(normalized_field)
          when 'risk_category'
            normalize_risk_category(normalized_field)
          else
            normalized_field
          end
      end
    end

    # ADDRESS NORMALIZATION METHODS

    def normalize_street(street)
      street&.gsub(/\./, '')
            &.gsub(/\bSt\b/i, 'Street')
            &.gsub(/\bAve\b/i, 'Avenue')
            &.upcase
    end

    def normalize_city(city)
      city =
        case city
        when "San Francisco", "S.F.", "SAN FRANCISCO", "SF", "SAN FANCISCO", "san francisco"
          "San Francisco"
        when "SO.S.F.", "South San Francisco", "So. S.F."
          "South San Francisco"
        when "Okland"
          "Oakland"
        when "Millvalley"
          "Mill Valley"
        else
          city
        end
      city&.upcase
    end

    def normalize_postal_code(postal_code, city: nil)
      case postal_code
      when "9411"
        "94110"
      when nil
        if city&.upcase == "SAN RAFAEL"
          "94903"
        elsif city&.upcase == "ANTIOCH"
          "94509"
        end
      else
        postal_code
      end
    end

    # NAME NORMALIZATION METHODS

    def normalize_restaurant_name(restaurant_name)
      case restaurant_name
      when "STARBUCKS", "STARBUCKS COFFEE", "Starbucks Coffee", "STARBUCKS COFFEE CO.", "Starbucks Coffee Company"
        "Starbucks Coffee"
      when "PEET'S COFFEE & TEA", "PEET'S COFFEES & TEAS", "Peet's Coffee & Tea", "Peet's Coffee & Tea, Inc"
        "Peet's Coffee & Tea"
      else
        restaurant_name
      end
    end

    def normalize_owner_name(owner_name)
      owner_name =
        case owner_name
        when "STARBUCKS COFFEE COMPANY", "STARBUCKS COFFEE CO.", "STARBUCKS CORP", "Starbucks Coffee Company", "Starbucks Coffee Co", "STARBUCKS COFFEE CORP", "Starbucks Corporation"
          "Starbucks Coffee Company"
        when "PANDA EXPRESS, INC.", "PANDA EXPRESS CO., INC."
          "Panda Express, Inc"
        when "Andre-Boudin Bakeries, Inc", "Andre Boudin Bakery, Inc."
          "Andre Boudin Bakery, Inc"
        when "PRACHIMA, INC", "PRACHIMA, INC."
          "Prachima, Inc."
        when "Peet's Coffee", "Peet's Coffee and Tea", "Peets Coffee & Tea, Inc"
          "Peet's Coffee & Tea, Inc"
        when "SAN FRANCISCO SOUP CO. LLC", "San Francisco Soup Company LLC"
          "San Francisco Soup Company LLC"
        when "The Ritz-Carlton Hotel Co", "The Ritz-Carlton Hotel Company."
          "The Ritz-Carlton Hotel Company"
        else
          owner_name
        end
      owner_name&.upcase
    end

    # ENUM NORMALIZATION METHODS

    def normalize_inspection_type(type)
      mapping = {
        "Routine - Unscheduled" => :routine_unscheduled,
        "Complaint" => :complaint,
        "Reinspection/Followup" => :reinspection_follow_up,
        "Foodborne Illness Investigation" => :foodborne_illness_investigation,
        "Non-inspection site visit" => :non_inspection_site_visit,
        "Routine - Scheduled" => :routine_scheduled,
        "New Ownership" => :new_ownership
      }
      mapping[type]
    end

    def normalize_risk_category(risk)
      case risk
      when /^low/i
        :low
      when /^moderate/i
        :moderate
      when /^high/i
        :high
      end
    end
  end
end
