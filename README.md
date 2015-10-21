# Rack::Cloudflare

A collection of middlewares that makes it nicer to work with Cloudflare.

Note that this middleware expects the app to behind another reverse proxy (HAProxy/nginx) with the last IP in `X-Forwarded-For` to be the IP of the client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-cloudflare', github: 'tatey/rack-cloudflare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-cloudflare

## Usage

Add these middlewares to your stack.

    # config/application.rb
    config.middleware.insert_before ActionDispatch::RemoteIp, Rack::Cloudflare::XForwardedFor
    config.middleware.insert_before Rack::Lock, Rack::Cloudflare::CacheControl

If you are using Railgun, specify the Railgun source IP by doing:

    # config/application.rb
    config.middleware.insert_before ActionDispatch::RemoteIp, Rack::Cloudflare::XForwardedFor, additional_ranges: ["<ip of railgun>/32"]


## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-cloudflare/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
