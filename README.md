# Riskified API Client

Ruby client for the [Riskified API](https://apiref.riskified.com) using [Typhoeus](https://github.com/typhoeus/typhoeus). Ruby 2.1 or newer is required.

The gem's declared minimum remains Ruby 2.1. The Ruby core team currently maintains MRI 3.3 (security maintenance), 3.4, and 4.0; those versions are covered by CI. Older Ruby branches are end-of-life and are not tested in CI.

## Installation

Add this line to your application's Gemfile:

    $ gem 'riskified_ruby', github: 'fcpeuro/riskified_ruby'

## Usage

### API keys

Credentials must be configured before you make API calls using the gem.

```ruby
Riskified.configure do |config|
  config.auth_token = 'rw342fdj534'
  config.default_referrer = 'www.example.com'
  config.sandbox_mode = true
end
```

* `config.auth_token` - your Riskified access key
* `config.default_referrer` - Default referrer
* `config.sandbox_mode` - Decide whether or not to use the sandbox endpoint

The keys are available to you throughout your application as:

```ruby
Riskified.configuration.auth_token
Riskified.configuration.default_referrer
Riskified.configuration.sandbox_mode
```

### Creating the client

```ruby
client = Riskified::Client.new
client.checkout_create(order)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Development checks

Install dependencies with `bundle install`, then run:

```sh
bundle exec rake
bundle exec standardrb
bundle exec brakeman --force --no-pager
```

CI runs the test suite on each currently maintained Ruby branch and runs StandardRB and Brakeman.
