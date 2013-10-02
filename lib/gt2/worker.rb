# This module contains common functionality for all workers, like massaging inputs, etc
module Gt2::Worker
  extend ActiveSupport::Concern

  extend Sidekiq::Worker

  included do
    alias_method :old_perform, :perform
    define_method(:perform) do |args|
      args = args.with_indifferent_access

      args[:time] = Date.parse(args[:time]) if args[:time]

      old_perform(args)
    end
  end

  def app_events(app_id)
    AppEvent.where(app_id: app_id, top_level: true)
  end
end