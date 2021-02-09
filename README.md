# MultiStore

MultiStore allows you to delegate to multiple ActiveSupport cache stores.
This makes it easy to implement behaviors such as "cache frequently used things locally, but infrequently used things remotely".

## Usage
Add an initializer that sets the rails cache, and tier your caches to your heart's content!

```ruby
stores = [
  ActiveSupport::Cache::MemoryStore.new,
  ActiveSupport::Cache::FileStore.new('/tmp/cache')
]
ActionController::Base.cache_store = :multi_store, stores
Rails.cache = ActionController::Base.cache_store
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_store

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WeTransfer/multi_store.

To run tests locally:

```bash
$ bundle && bundle exec rake spec
```
