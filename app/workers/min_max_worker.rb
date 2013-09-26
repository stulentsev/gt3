class MinMaxWorker
  include Sidekiq::Worker

  def perform(args)
    app_id = args.fetch(:app_id)
    time = args.fetch(:time)

    updates = {}
    app_events.each do |event|
      val = Rails.configuration.redis_wrapper.get_min_value(app_id, event, time)
      updates.deep_merge!(prepare_update_opts(:min, event, val))

      val = Rails.configuration.redis_wrapper.get_max_value(app_id, event, time)
      updates.deep_merge!(prepare_update_opts(:max, event, val))
    end

    doc_id = "#{app_id}_#{time.compact}"
    DailyStat.update_stats(doc_id, updates)

    # TODO: expire keys
  end

  private
  def prepare_update_opts(type, event, val)
    {:$set => {"aggs.#{event}.#{type}" => val}}
  end
end