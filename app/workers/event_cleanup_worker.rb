class EventCleanupWorker
  include Sidekiq::Worker

  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    AppEvent.where(:updated_at.lt => 30.days.ago).each do |ae|
      # remove subevents
      AppEvent.delete_all(_id: Regexp.new(ae.id))

      ae.destroy
    end
  end
end