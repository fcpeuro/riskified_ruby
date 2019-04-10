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
  config.default_shop_domain = 'www.example.nl'
  config.default_referrer = 'www.example.nl'
  config.sandbox_mode = true  # if using rails: !Rails.env.production?
end
```

You can set these values in your `.env` file 

```dotenv
RISKIFIED_DEFAULT_SHOP_DOMAIN=www.example.nl
RISKIFIED_DEFAULT_REFERRER=www.example.nl
RISKIFIED_AUTH_TOKEN=xyz123
```

* `config.auth_token` - your Riskified access key
* `config.default_referrer` - Default referrer
* `config.default_shop_domain` - Shop domain
* `config.sandbox_mode` - Decide whether or not to use the sandbox endpoint

The keys are available to you throughout your application as:

```ruby
Riskified.config.auth_token
Riskified.config.default_shop_domain
Riskified.config.default_referrer
Riskified.config.sandbox_mode
```

### Creating the client

```ruby
client = Riskified::Client.new
order = Riskified::Entities::Order.new
client.decide(order, 'www.custom-shop-domain.test')
```
