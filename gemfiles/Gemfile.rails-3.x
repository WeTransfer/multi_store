source "http://rubygems.org"
gem 'activesupport', "~> 3"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem 'rack', '~> 1' # Required for ActiveSupport store to work 
  gem 'rake', '~> 10.0'
  gem "rspec", "~> 2.4"
  gem "rdoc", "~> 3.12"
  gem "bundler", "~> 1.0"
  gem "redis-activesupport"
end
