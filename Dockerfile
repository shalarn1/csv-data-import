FROM ruby:3.3.5

WORKDIR /instrumentl

COPY . /instrumentl

RUN bundle install
