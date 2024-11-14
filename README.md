# README

Ruby 3.3.5 / Rails 7.0.8

## Install

#### Clone the repository
```shell
git clone git@github.com:shalarn1/instrumentl.git
cd instrumentl
```

# Local development without Docker

### Ensure ruby version and bundler are installed, initialize the database & import data. Analyze_csv is not necessary to run
```shell
bundle install
bundle exec rake db:create
bundle exec rake db:setup
bundle exec rake data_import:import_data
bundle exec rake data_import:analyze_csv
```

### To start the rails console and/or server
Make sure postgres is running
```shell
bundle exec rails console
bundle exec rails server
```

# Local development with Docker

The only local depedency should be Docker.

Once Docker is running:

Build image and install app dependencies:

`docker compose build web`

#### DB setup

`docker compose run web bin/rails db:create`
`docker compose run web bin/rails db:schema:load`

### Running the app

`docker compose up`

#### Immport data from csv

`docker compose run web bin/rails data_import:import_data`

#### Rails console

`docker compose run web rails console`

#### Tests / Rspec

`docker compose run web rspec spec/models/*.rb`

### Analyze data from csv (not necessary to populate db)
`docker compose run web bin/rails data_import:analyze_csv`

Troubleshooting if needed,

#### Reset DB

`docker compose run web bin/rails db:drop`

`docker compose run web bin/rails db:create`

`docker compose run web bin/rails db:schema:load`

#### DB migration

`docker compose run web bin/rails db:migrate`

#### Gem installation

`docker compose run web bundle install`

#### Notes
Relevant files for review:

`lib/data_import.rake`
`db/migrate/*.rb`
`app/models/*.rb`
`db/schema.rb`

`spec/factories/*.rb`
`spec/models/*.rb`

`Gemfile`
`Dockerfile`
`docker-compose.yml`
`config/database.yml`


Go to http://localhost:3000 in your browser

# Backend Project

Given the following CSV of San Francisco restaurants, their inspections, and code violations, design a relational (SQL) DB schema that could be used to *power a performant API* while storing large numbers of records. Then, build a process to import the data from the CSV.

Please leverage Ruby on Rails as well as any additional technologies you prefer. Please provide comments, documentation as appropriate, and be prepared to discuss ways you would modify your schema and import process to address new requirements.

The designed system should be able to *power a performant API* in the future that could handle large amounts of data, so be sure to consider data quality and access performance.

[SF Restaurant CSV](https://drive.google.com/file/d/1Hc-jbBUTeYiur4mFLzff-tupCpT5lm82/view?usp=sharing)

The project should work! Please include setup and running steps before submitting for review and make sure your project runs from a clean checkout.

Notes:
https://sarika-halarnakar.notion.site/Instrumentl-Backend-Kick-Off-13ddd81f57b1805cad7fddff3443634f?pvs=4

Strategy
1. Manually parse through CSV to get general idea of db system and options
2. Write script to parse through CSV and finds all options (cities, postal codes, inspection type, violation type/risk category/description).
3. Create DB & populate enums with findings
4. Script to parse through CSV and add to DB. Attempt to standardize certain fields like city, postal code, owner name, some restaurant names etc

I only found inconsistent data in a handful of places so I decided to sanitize on db entry instead of writing a cleaner CSV and using that for the data entry as I didn't think it made sense to write a new 5000 entry csv for just a couple entries.

If I spent more time on this, 

1) Potentially create a RestaurantGroup type for restaurants of the same name but with multiple addresses as well as updating the Owner/Address relationship to be many-to-many, probably a join table on restaurant_id/owner_id/address_id where address is the particular owner's address that's associated with that restaurant location. I decided to create a new entry for each name/address pair for both restaurants and owners, keeping the many-to-one relationship I originally established. In the case of inspections it's maybe ok/relevant to keep the database simple with distinct restaurants/address and owner/address pairs rather than to keep track of an entity with many addresses.  I normalized the some of the names so at least all the addresses could come up for the same owner if needed.

2) Integrate with Google Address Validator API. I tried to implement it but I couldn't get it working due to some conflicting dependencies and I wasn't sure if it was worth the trouble. I tried to normalize the data the best I could without it but I've probably missed a few.


3) Define all normalizing methods in a separate file in /lib. I was hopeful that I could normalize the fields using ActiveRecord callbacks but that didn't work out because the normalization doesn't apply to the find portion and find_and_create. So, I just converted them to class methods on the model in the interest of time. The most ideal option may have been to define a method find_or_create_normalized or maybe add a scope for the find so the normalization could be kept in the active record callbacks.


