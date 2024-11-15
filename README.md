# README

Ruby 3.3.5 / Rails 7.0.8

## Install

#### Clone the repository
```shell
git clone git@github.com:shalarn1/instrumentl.git
cd instrumentl
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
`docker compose run web bin/rails analysis:analyze_csv`

Troubleshooting if needed,

#### Reset DB

`docker compose run web bin/rails db:drop`

`docker compose run web bin/rails db:create`

`docker compose run web bin/rails db:schema:load`

#### DB migration

`docker compose run web bin/rails db:migrate`

#### Gem installation

`docker compose run web bundle install`

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

#### Notes
Relevant files for review:

`lib/data_import.rake`
`db/migrate/*.rb`
`app/models/*.rb`
`app/lib/*.rb`
`db/schema.rb`

`spec/factories/*.rb`
`spec/models/*.rb`
`spec/lib/*.rb`

`lib/analysis.rake` - optional, just my scratchwork

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

I only found inconsistent data in a handful of places so I decided to sanitize on db entry vs writing a new cleaner CSV to use for data entry.

I made the baseline assumption that the provided CSV data is the only dataset that will be imported. Upon importing a new CSV, the system would need to be able to address non-matching data for model definitions such as the enums and non-null columns.

Notes, 

1) Without a defined API it's hard to know what to optimize for, performance wise. I decided on indexes based on the looks up in the import script and what was the most reliable information to identify unique entries (ie street/postal code, name/address).

2) It could use a RestaurantGroup to cover all the restaurants with the same name but different addresses and it could support a many-to-many relationship for owners and addresses (a join table on restaurant_id/owner_id/address_id where address is the corresponds to the owner's address).

In this context the extra complexity didn't seem necessary so I opt-ed for a more simple one-to-many relationship with distinct restaurants/address and owner/address pairs. 

3) It could use the Google Address Validator API. This would make sure that addresses are accurate and there aren't unnecessary duplicates in the DB. However, it does add an increased cost and a third party API call to what’s currently a synchronous task, so it depends if the added accuracy was worth the tradeoffs

4) I opted for a more basic approach to data normalization to cover all the edge cases for this data. I normalized some fields on the address and owner but I preserved the restaurant names for the most part. This may cause some data integrity issues as the fields are not perfectly consistent. I combed through data to determine the safest assumptions to make. For some user input data, it may be more beneficial preserve duplicates rather than potentially lose distinguishing data unless we are certain of an error.



