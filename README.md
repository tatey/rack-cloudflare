# Rack::Cloudflare

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-cloudflare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-cloudflare

## Usage

Add these middlewares to your stack.

    # config/application.rb
    config.middleware.insert_before ActionDispatch::RemoteIp, Middleware::CloudFlare::XForwardedFor
    config.middleware.insert_before ActionDispatch::Static, Middleware::CloudFlare::CacheControl

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-cloudflare/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
