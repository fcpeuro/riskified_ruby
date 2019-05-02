# Riskified API Client

Ruby client for the [Riskified API](https://apiref.riskified.com) using [Faraday](https://github.com/technoweenie/faraday).  Ruby > 2.0 is required.

This Ruby client currently only supports the Sync flow.

## Installation

Add this line to your application's Gemfile:

    $ gem 'riskified_ruby', github: 'cgservices/riskified_ruby'

## Usage

### API keys

Credentials must be configured before you make API calls using the gem.

```ruby
Riskified.configure do |config|
  config.auth_token = 'xyz123'
  config.shop_domain = 'www.example.nl'
  config.default_referrer = 'www.example.nl'
  config.sandbox_mode = true  # if using rails: !Rails.env.production?
end
```

* `config.auth_token` - your Riskified access key
* `config.default_referrer` - Default referrer
* `config.shop_domain` - Shop domain
* `config.sandbox_mode` - Decide whether or not to use the sandbox endpoint

The keys are available to you throughout your application as:

```ruby
Riskified.config.auth_token
Riskified.config.shop_domain
Riskified.config.default_referrer
Riskified.config.sandbox_mode
```

### Creating the client

```ruby
client = Riskified::Client.new
order = Riskified::Entities::Order.new
client.decide(order)
```
