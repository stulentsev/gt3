class Gt2::DummyDataGenerator
  def call(app_id, opts = {})
    app_id = app_id
    ndays = opts.fetch(:ndays) { 30 }
    offset = opts.fetch(:offset) { 0 }

    clear_existing_stats_for_app(app_id)

    offset.upto(offset + ndays).each do |x|
      generate_day_data(app_id, x.days.ago)
    end
  end

  private
  def generate_day_data(app_id, d)
    generate_regular_events(app_id, d)
    generate_numerical_events(app_id, d)
    generate_enum_events(app_id, d)

    run_workers(app_id, d)
  end

  def generate_regular_events(app_id, d)
    rand(30..50).times do
      es = EventSaver.new(time: d, event: 'load app', user_id: rand(100), app_id: app_id)
      es.save
    end
  end

  def generate_numerical_events(app_id, d)
    rand(20..30).times do
      es = EventSaver.new(time: d, event: 'earn xp', user_id: rand(100), app_id: app_id, value: rand(1000))
      es.save
    end
  end

  def generate_enum_events(app_id, d)
    rand(30..40).times do
      options = ['comedy', 'fantasy', 'action', 'science fiction']

      es = EventSaver.new(time: d, event: 'movie category', user_id: rand(100), app_id: app_id, value: options.sample)
      es.save
    end
  end

  def run_workers(app_id, d)
    EventUniquesWorker.new.perform(app_id: app_id, time: d.to_s)
    MinMaxWorker.new.perform(app_id: app_id, time: d.to_s)
    AuWorker::Daily.new.perform(app_id: app_id, time: d.to_s)
    AuWorker::Monthly.new.perform(app_id: app_id, time: d.to_s)
  end

  def clear_existing_stats_for_app(app_id)
    DailyStat.where(app_id: app_id).destroy
  end
end