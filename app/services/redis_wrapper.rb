class RedisWrapper
  def initialize(redis)
    @redis = redis
  end

  attr_reader :redis

  def add_event_unique(app_id, event, user_id)
    k = "event_uniques:#{app_id}:#{event}:#{time.compact}"
    redis.sadd(k, user_id)
  end

  def get_event_uniques(app_id, event)
    k = "event_uniques:#{app_id}:#{event}:#{time.compact}"
    redis.scard(k)
  end

  def add_dau(app_id, user_id)
    k = "dau:#{app_id}:#{time.compact}"
    redis.sadd(k, user_id)
  end

  def get_dau(app_id)
    k = "dau:#{app_id}:#{time.compact}"
    redis.scard(k)
  end

  def add_mau(app_id, user_id)
    k = "mau:#{app_id}:#{time.strftime('%Y%m')}"
    redis.sadd(k, user_id)
  end

  def get_mau(app_id)
    k = "mau:#{app_id}:#{time.strftime('%Y%m')}"
    redis.scard(k)
  end

  def get_min_value(app_id, event)
    k = "min_value:#{app_id}:#{event}:#{time.compact}"
    redis.get(k).to_f
  end

  def set_min_value(app_id, event, value)
    k = "min_value:#{app_id}:#{event}:#{time.compact}"

    redis.eval min_value_script, [k], [value]
  end

  def get_max_value(app_id, event)
    k = "max_value:#{app_id}:#{event}:#{time.compact}"
    redis.get(k).to_f
  end

  def set_max_value(app_id, event, value)
    k = "max_value:#{app_id}:#{event}:#{time.compact}"

    redis.eval max_value_script, [k], [value]
  end

  private
  def time
    Time.now
  end

  def min_value_script
    <<-LUA
    local existing = tonumber(redis.call('get', KEYS[1]))
    local new = tonumber(ARGV[1])
    if (existing == nil or new < existing) then
      redis.call('set', KEYS[1], new)
      return tostring(new)
    else
      return tostring(existing)
    end
    LUA
  end

  def max_value_script
    <<-LUA
    local existing = tonumber(redis.call('get', KEYS[1]))
    local new = tonumber(ARGV[1])
    if (existing == nil or new > existing) then
      redis.call('set', KEYS[1], new)
      return tostring(new)
    else
      return tostring(existing)
    end
    LUA
  end
end