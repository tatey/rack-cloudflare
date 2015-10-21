require "rack/cloudflare/version"
require "ipaddr"

module Rack
  module Cloudflare
    class CacheControl
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        if status.to_s == '404'
          [status, headers.merge('Cache-Control' => 'no-cache'), body]
        else
          [status, headers, body]
        end
      end
    end

    class XForwardedFor
      IP_FILE = ::File.expand_path(::File.join(::File.dirname(__FILE__), "cloudflare", "ips.txt"))
      CLOUDFLARE_IP_RANGES = ::File.readlines(IP_FILE)

      def initialize(app, options = {})
        @app = app
        @ip_ranges = (CLOUDFLARE_IP_RANGES + options.fetch(:additional_ranges, [])).map do |range|
          IPAddr.new(range)
        end
      end

      def call(env)
        fwd = (env['HTTP_X_FORWARDED_FOR'] || '').split(/, /)
        if env['HTTP_CF_CONNECTING_IP'] && fwd.last && @ip_ranges.any? { |range| range.include?(fwd.last) }
          env['HTTP_REMOTE_ADDR_BEFORE_CF'] = env['REMOTE_ADDR']
          env['HTTP_X_FORWARDED_FOR_BEFORE_CF'] = env['HTTP_X_FORWARDED_FOR']
          env['REMOTE_ADDR'] = env['HTTP_CF_CONNECTING_IP']
          env['HTTP_X_FORWARDED_FOR'] = env['HTTP_CF_CONNECTING_IP']
        end
        @app.call(env)
      end
    end
  end
end
