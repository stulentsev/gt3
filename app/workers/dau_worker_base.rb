class DauWorkerBase
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly.minute_of_hour(0, 15, 30, 45) }

  def perform(args)
    app_id = args.fetch(:app_id)
    time = args.fetch(:time)

    # self.type is a method to be redefined in descendants. For now it can return :dau or :mau
    get_method = "get_#{type}" # get_dau or get_mau
    expire_method = "expire_#{type}_key" # expire_dau_key, ...

    val = Rails.configuration.redis_wrapper.send(get_method, app_id, time)

    doc_id, updates = prepare_update_opts(app_id, time, val)
    DailyStat.update_stats(doc_id, updates)

    Rails.configuration.redis_wrapper.send(expire_method, app_id, time)
  end

  private
  def prepare_update_opts(app_id, time, val)
    id = "#{app_id}_#{time.compact}"
    opts = {:$set => {"system.#{type}" => val}}

    [id, opts]
  end
end
