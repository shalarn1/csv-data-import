# README

Ruby 3.3.5 / Rails 7.0.8

## Install

#### Clone the repository
```shell
git clone git@github.com:shalarn1/instrumentl.git
cd instrumentl
```

#### Ensure ruby version and bundler are installed
Download and install all of the Ruby gems (dependencies) in Gemfile.lock
```shell
bundle install
```

### Initialize the database
```shell
bundle exec rake db:create
bundle exec rake db:setup
```

### Import data from csv
```shell
bundle exec rake data_import:import_data
```
### Analyze data from csv
```shell
bundle exec rake data_import:analyze_csv
```

### Start the rails server
Make sure postgres is running
```shell
bundle exec rails server
```

Go to http://localhost:3000 in your browser

# Backend Project

Given the following CSV of San Francisco restaurants, their inspections, and code violations, design a relational (SQL) DB schema that could be used to *power a performant API* while storing large numbers of records. Then, build a process to import the data from the CSV.

Please leverage Ruby on Rails as well as any additional technologies you prefer. Please provide comments, documentation as appropriate, and be prepared to discuss ways you would modify your schema and import process to address new requirements.

The designed system should be able to *power a performant API* in the future that could handle large amounts of data, so be sure to consider data quality and access performance.

[SF Restaurant CSV](https://drive.google.com/file/d/1Hc-jbBUTeYiur4mFLzff-tupCpT5lm82/view?usp=sharing)

The project should work! Please include setup and running steps before submitting for review and make sure your project runs from a clean checkout.

1. Manually parse through CSV to get general idea of db system and options
2. Write script parses through CSV and finds all options (cities, inspection type, violation type/risk category/description). Standardize certain fields like city, postal code, owner name etc
3. Create DB & populate enums with findings
4. Script to parse through CSV and add to DB

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
