class RedisWrapper
  def initialize(redis)
    @redis = redis
  end

  attr_reader :redis

  def add_event_unique(app_id, event, user_id, time = self.time)
    k = keyname_for_event_uniques(app_id, event, time)
    redis.sadd(k, user_id)
  end

  def get_event_uniques(app_id, event, time = self.time)
    k = keyname_for_event_uniques(app_id, event, time)
    redis.scard(k)
  end

  def add_dau(app_id, user_id, time = self.time)
    k = keyname_for_dau(app_id, time)
    redis.sadd(k, user_id)
  end

  def get_dau(app_id, time = self.time)
    k = keyname_for_dau(app_id, time)
    redis.scard(k)
  end

  def expire_dau_key(app_id, time = self.time)
    k = keyname_for_dau(app_id, time)
    redis.expire(k, 30.days)
  end

  def add_mau(app_id, user_id, time = self.time)
    k = keyname_for_mau(app_id, time)
    redis.sadd(k, user_id)
  end

  def get_mau(app_id, time = self.time)
    k = keyname_for_mau(app_id, time)
    redis.scard(k)
  end

  def expire_mau_key(app_id, time = self.time)
    k = keyname_for_mau(app_id, time)
    redis.expire(k, 30.days)
  end

  def get_min_value(app_id, event, time = self.time)
    k = keyname_for_min_value(app_id, event, time)
    res = redis.get(k)
    res ? res.to_f : nil
  end

  def set_min_value(app_id, event, value, time = self.time)
    k = keyname_for_min_value(app_id, event, time)
    redis.eval min_value_script, [k], [value]
  end

  def get_max_value(app_id, event, time = self.time)
    k = keyname_for_max_value(app_id, event, time)
    res = redis.get(k)
    res ? res.to_f : nil
  end

  def set_max_value(app_id, event, value, time = self.time)
    k = keyname_for_max_value(app_id, event, time)
    redis.eval max_value_script, [k], [value]
  end

  def get_current_value(app_id, event, time = self.time)
    k = keyname_for_current_value(app_id, event, time)
    redis.get(k)
  end

  def set_current_value(app_id, event, value, time = self.time)
    k = keyname_for_current_value(app_id, event, time)
    redis.setex(k, 1.day, value)
  end

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

  def keyname_for_event_uniques(app_id, event, time)
    "event_uniques:#{app_id}:#{event}:#{time.compact}"
  end

  def keyname_for_dau(app_id, time)
    "dau:#{app_id}:#{time.compact}"
  end

  def keyname_for_mau(app_id, time)
    "mau:#{app_id}:#{time.strftime('%Y%m')}"
  end

  def keyname_for_min_value(app_id, event, time)
    "min_value:#{app_id}:#{event}:#{time.compact}"
  end

  def keyname_for_max_value(app_id, event, time)
    "max_value:#{app_id}:#{event}:#{time.compact}"
  end

  def keyname_for_current_value(app_id, event, time)
    "current_value:#{app_id}:#{event}:#{time.compact}"
  end
end