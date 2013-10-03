class SaverWorker
  include Sidekiq::Worker

  def perform(params)
    saver = EventSaver.new(params)
    saver.save
  end
end