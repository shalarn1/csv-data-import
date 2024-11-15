require './app/lib/normalizer'
require 'securerandom'

describe Normalizer do
  describe '::normalize_street' do
    it 'removes periods, normalizes abbreviations, and capitalizes' do
      expect(Normalizer.normalize_street('123 Main St.')).to eq('123 MAIN STREET')
      expect(Normalizer.normalize_street('123 Main ST')).to eq('123 MAIN STREET')
      expect(Normalizer.normalize_street('123 Main st')).to eq('123 MAIN STREET')
      expect(Normalizer.normalize_street('890 Oak Ave.')).to eq('890 OAK AVENUE')
      expect(Normalizer.normalize_street('890 Oak Ave')).to eq('890 OAK AVENUE')
      expect(Normalizer.normalize_street('890 Oak AVE')).to eq('890 OAK AVENUE')
      expect(Normalizer.normalize_street('567 Elm Street')).to eq('567 ELM STREET')
      expect(Normalizer.normalize_street('123 4th Avenue')).to eq('123 4TH AVENUE')
    end

    it 'handles nil input' do
      expect(Normalizer.normalize_street(nil)).to be_nil
    end
  end

  describe '::normalize_city' do
    [
      [["San Francisco", "S.F.", "SAN FRANCISCO", "SF", "SAN FANCISCO", "san francisco"], 'SAN FRANCISCO'],
      [["SO.S.F.", "South San Francisco", "So. S.F."], "SOUTH SAN FRANCISCO"],
      [["Okland"], 'OAKLAND'],
      [["DALY CITY", "Daly City"], "DALY CITY"],
      [["Millvalley"], "MILL VALLEY"],
      [["SAN RAFAEL", "San Rafael"], 'SAN RAFAEL']
    ].each do |city_names, result|
      city_names.each do |city|
        context "when city is #{city}" do
          it 'normalizes to the right city name' do
            expect(Normalizer.normalize_city(city)).to eq(result)
          end
        end
      end
    end

    ["BERKELEY", "WASHINGTON", "Menlo Park", "SEATTLE", "MILLBRAE", "Mountain View", "BRISBANE", "KNOXVILLE",
     "KENWOOD", "EMERYVILLE", "GREENVILLE", "ROSEMEAD", "Richmond", "Seattle", "Larkspur", "MURRAY", "Brea",
     "ANTIOCH", "PACIFICA", "DANVILLE"].each do |city|
      context "when city is #{city}" do
        it 'returns the city' do
          expect(Normalizer.normalize_city(city)).to eq(city.upcase)
        end
      end
    end

    context 'when city is nil' do
      it 'stays nil' do
        expect(Normalizer.normalize_city(nil)).to be_nil
      end
    end
  end

  describe '::normalize_postal_code' do
    it 'normalizes 9411 to 94110' do
      expect(Normalizer.normalize_postal_code('9411')).to eq('94110')
    end

    it 'normalizes nil postal code for San Rafael' do
      expect(Normalizer.normalize_postal_code(nil, city: 'San Rafael')).to eq('94903')
    end

    it 'normalizes nil postal code for Antioch' do
      expect(Normalizer.normalize_postal_code(nil, city: 'Antioch')).to eq('94509')
    end

    it 'returns the original postal code if not in the mapping' do
      expect(Normalizer.normalize_postal_code('94103')).to eq('94103')
      expect(Normalizer.normalize_postal_code(nil, city: SecureRandom.hex)).to be_nil
    end
  end

  describe '::normalize_restaurant_name' do
    ["STARBUCKS", "STARBUCKS COFFEE", "Starbucks Coffee", "STARBUCKS COFFEE CO.",
     "Starbucks Coffee Company"].each do |starbucks_variant|
      it 'normalizes Starbucks variants' do
        expect(Normalizer.normalize_restaurant_name(starbucks_variant)).to eq('Starbucks Coffee')
      end
    end

    ["PEET'S COFFEE & TEA", "PEET'S COFFEES & TEAS", "Peet's Coffee & Tea",
     "Peet's Coffee & Tea, Inc"].each do |peets_variant|
      it "normalizes Peet's Coffee & Tea variants" do
        expect(Normalizer.normalize_restaurant_name(peets_variant)).to eq("Peet's Coffee & Tea")
      end
    end

    let(:og_name) { SecureRandom.hex }
    it 'returns the original name for other restaurants' do
      expect(Normalizer.normalize_restaurant_name(og_name)).to eq(og_name)
    end
  end

  describe '::normalize_owner_name' do
    let(:starbucks) { "Starbucks Coffee Company" }
    let(:peets) { "Peet's Coffee & Tea, Inc" }
    ["STARBUCKS COFFEE COMPANY", "STARBUCKS COFFEE CO.", "STARBUCKS CORP", "Starbucks Coffee Company",
     "Starbucks Coffee Co", "STARBUCKS COFFEE CORP", "Starbucks Corporation"].each do |starbucks_variant|
      it 'normalizes Starbucks owner variants' do
        expect(Normalizer.normalize_owner_name(starbucks_variant)).to eq(starbucks.upcase)
      end
    end

    ["Peet's Coffee", "Peet's Coffee and Tea", "Peets Coffee & Tea, Inc"].each do |peets_variant|
      it "normalizes Peet's Coffee & Tea owner variants" do
        expect(Normalizer.normalize_owner_name(peets_variant)).to eq(peets.upcase)
      end
    end

    # TODO: Cover more cases

    let(:og_name) { SecureRandom.hex }
    it 'capitalizes the name for other owners' do
      expect(Normalizer.normalize_owner_name(og_name)).to eq(og_name.upcase)
    end
  end

  describe '::normalize_inspection_type' do
    it 'maps known inspection types' do
      expect(Normalizer.normalize_inspection_type('Routine - Unscheduled')).to eq(:routine_unscheduled)
      expect(Normalizer.normalize_inspection_type('Complaint')).to eq(:complaint)
      expect(Normalizer.normalize_inspection_type('Reinspection/Followup')).to eq(:reinspection_follow_up)
      expect(Normalizer.normalize_inspection_type('Foodborne Illness Investigation')).to eq(:foodborne_illness_investigation)
      expect(Normalizer.normalize_inspection_type('Non-inspection site visit')).to eq(:non_inspection_site_visit)
      expect(Normalizer.normalize_inspection_type('Routine - Scheduled')).to eq(:routine_scheduled)
      expect(Normalizer.normalize_inspection_type('New Ownership')).to eq(:new_ownership)
    end

    it 'returns nil for unknown inspection types' do
      expect(Normalizer.normalize_inspection_type(SecureRandom.hex)).to be_nil
    end
  end

  describe '::normalize_risk_category' do
    let(:low_risk) { 'Low Risk' }
    let(:moderate_risk) { 'Moderate Risk' }
    let(:high_risk) { 'High Risk' }
    let(:invalid_risk) { SecureRandom.hex }

    it 'normalizes risk to the right enum' do
      expect(Normalizer.normalize_risk_category(low_risk)).to eq(:low)
      expect(Normalizer.normalize_risk_category(moderate_risk)).to eq(:moderate)
      expect(Normalizer.normalize_risk_category(high_risk)).to eq(:high)
      expect(Normalizer.normalize_risk_category(invalid_risk)).to be_nil
    end
  end
end
