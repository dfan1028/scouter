# frozen_string_literal: true

require 'net/http'

module ProxyFinder
  PROXY_URL = "https://www.proxy-list.download/api/v1/get"

  PROXY_ARGS = {
    type: 'https',
    anon: 'elite',
    country: 'US'
  }

  module_function

  def get_proxy
    get_more_proxies unless proxies.any?

    random_proxy
  end

  def remove_proxy(proxy)
    $redis.srem(proxy_cache_key, proxy)
  end

  def get_more_proxies
    parse_response(fetch_raw_proxies).each do |proxy|
      $redis.sadd(proxy_cache_key, proxy)
    end
  end

  def random_proxy
    $redis.srandmember(proxy_cache_key)
  end

  def clear
    $redis.del(proxy_cache_key)
  end

  def proxies
    $redis.smembers(proxy_cache_key)
  end

  def parse_response(raw_proxies)
    raw_proxies.split("\r\n")
  end

  def fetch_raw_proxies
    uri = URI.parse(PROXY_URL)
    uri.query = Rack::Utils.build_nested_query(PROXY_ARGS)

    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    req.get(uri).body
  end

  def proxy_cache_key
    'products:proxy_finder'
  end
end
