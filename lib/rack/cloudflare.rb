require "rack/cloudflare/version"

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
      CLOUDFLARE_IP_RANGES = %w(
        199.27.128.0/21
        173.245.48.0/20
        103.21.244.0/22
        103.22.200.0/22
        103.31.4.0/22
        141.101.64.0/18
        108.162.192.0/18
        190.93.240.0/20
        188.114.96.0/20
        197.234.240.0/22
        198.41.128.0/17
        162.158.0.0/15
        104.16.0.0/12
      ).map do |range|
        IPAddr.new(range)
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        fwd = (env['HTTP_X_FORWARDED_FOR'] || '').split(/, /)
        if env['HTTP_CF_CONNECTING_IP'] && fwd.last && CLOUDFLARE_IP_RANGES.any? { |range| range.include?(fwd.last) }
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
