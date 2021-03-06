class AuWorker
  include Sidekiq::Worker
  include Gt2::Worker

  def perform(args)
    args = args.with_indifferent_access
    args[:time] = Date.parse(args[:time]) if args[:time]

    app_id        = args.fetch(:app_id)
    time          = args.fetch(:time)

    # self.type is a method to be redefined in descendants. For now it can return :dau or :mau
    get_method    = "get_#{type}"        # get_dau or get_mau
    expire_method = "expire_#{type}_key" # expire_dau_key, ...

    val = Rails.configuration.redis_wrapper.send(get_method, app_id, time)

    doc_id, updates = prepare_update_opts(app_id, time, val)
    DailyStat.update_stats(doc_id, updates)

    Rails.configuration.redis_wrapper.send(expire_method, app_id, time)
  end

  class Daily < self
    def type
      :dau
    end
  end

  class Monthly < self
    def type
      :mau
    end
  end

  private
  def prepare_update_opts(app_id, time, val)
    id   = "#{app_id}_#{time.compact}"
    opts = { :$set => { "system.#{type}" => val } }

    [id, opts]
  end
end

