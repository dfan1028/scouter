# frozen_string_literal: true

module Locksmith
  Locked = Class.new(StandardError)

  module_function

  def lock(key, &block)
    if $redis.setnx(key, true)
      # Automatically unlock in 2 mins to prevent
      # keys from being held forever
      $redis.expire(key, 2.minutes)

      block.call.tap do
        $redis.del(key)
      end
    else
      raise Locked.new("[LOCKED]: #{key}")
    end
  end

  def unlock(key)
    $redis.del(key)
  end

end
