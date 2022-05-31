# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}"
end

gemspec

group :development, :test do
  gem "rspec"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "standard"
end
