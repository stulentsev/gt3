class Gt2::DummyDataGenerator
  def call(app_id, opts = {})
    app_id = app_id
    ndays = opts.fetch(:ndays) { 30 }
    offset = opts.fetch(:offset) { 0 }

    DailyStat.where(app_id: app_id).destroy

    offset.upto(offset + ndays).each do |x|
      d = x.days.ago

      rand(30..50).times do
        es = EventSaver.new(time: d, event: 'load app', user_id: rand(100), app_id: app_id)
        es.save
      end

      EventUniquesWorker.new.perform(app_id: app_id, time: d.to_s)
      MinMaxWorker.new.perform(app_id: app_id, time: d.to_s)
      AuWorker::Daily.new.perform(app_id: app_id, time: d.to_s)
      AuWorker::Monthly.new.perform(app_id: app_id, time: d.to_s)
    end
  end
end

#app = App.find('524d44c00ed4c03e88000002')
#gen = Gt2::DummyDataGenerator.new.call(app.id)