class UniqueFlushScheduler
  include Gt2::Worker
  include Sidetiq::Schedulable

  #recurrence { hourly.minute_of_hour(0, 15, 30, 45) }
  recurrence { minutely }

  def perform(_at, _last)
    schedule_for_each_app AuWorker::Daily
    schedule_for_each_app AuWorker::Monthly
    schedule_for_each_app EventUniquesWorker
    schedule_for_each_app MinMaxWorker
  end


  private
  def schedule_for_each_app(klass)
    App.all.each do |app|
      klass.perform_async app_id: app.id.to_s, time: Time.now
    end
  end

end