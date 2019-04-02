# Riskified API Client

Ruby client for the [Riskified API](https://apiref.riskified.com) using [Faraday](https://github.com/technoweenie/faraday).  Ruby > 2.0 is required.

## Installation

Add this line to your application's Gemfile:

    $ gem 'riskified_ruby', github: 'cgservices/riskified_ruby'

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
