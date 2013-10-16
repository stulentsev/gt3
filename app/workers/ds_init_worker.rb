class DsInitWorker
  include Sidekiq::Worker

  def perform(args)
    args = args.with_indifferent_access
    args[:time] = Date.parse(args[:time]) if args[:time]

    app_id = args.fetch(:app_id)
    time   = args.fetch(:time)

    doc_id, updates = prepare_update_opts(app_id, time)
    DailyStat.update_stats(doc_id, updates)
  end

  private
  def prepare_update_opts(app_id, time)
    id = "#{app_id}_#{time.compact}"

    defaults = DailyStat.new.attributes.except('_id')

    opts = { :$setOnInsert => defaults,
             :$set         => { app_id: app_id.to_s, time: time.compact }
    }

    [id, opts]
  end
end