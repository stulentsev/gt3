class DauWorkerBase
  include Sidekiq::Worker

  def perform(args)
    app_id = args.fetch(:app_id)
    time = args.fetch(:time)

    get_method = "get_#{type}"
    expire_method = "expire_#{type}_key"

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