class EventUniquesWorker
  include Sidekiq::Worker

  def perform(args)
    app_id = args.fetch(:app_id)
    time = args.fetch(:time)

    updates = {}
    app_events.each do |event|
      val = Rails.configuration.redis_wrapper.get_event_uniques(app_id, event, time)
      updates.deep_merge!(prepare_update_opts(event, val))
    end

    doc_id = "#{app_id}_#{time.compact}"
    DailyStat.update_stats(doc_id, updates)

    # TODO: expire keys
  end

  private
  def prepare_update_opts(event, val)
    {:$set => {"stats.#{event}.unique" => val}}
  end
end