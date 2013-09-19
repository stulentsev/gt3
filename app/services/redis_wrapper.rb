class RedisWrapper
  def initialize(redis)
    @redis = redis
  end

  attr_reader :redis

  def add_event_unique(app_id, event, user_id)
    t = Time.now.compact
    k = "event_uniques:#{app_id}:#{event}:#{t}"
    redis.sadd(k, user_id)
  end
end