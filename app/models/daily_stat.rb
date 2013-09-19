class DailyStat
  include Mongoid::Document

  field :_id, type: String, default: -> { "#{app_id}_#{date.compact}" }
  field :app_id, type: String
  field :date, type: DateTime

  field :stats, type: Hash, default: {}
  field :counts, type: Hash, default: {}
  field :aggs, type: Hash, default: {}

  scope :today_stat, ->(app_id) { where(_id: "#{app_id}_#{Time.now.compact}") }

  def self.update_stats(id, updates)
    # Use moped session directly to update multiple field atomically

    # session[:artists].find(name: "Syd Vicious").update(:$push => { instruments: { name: "Bass" }})
    Mongoid::Sessions.default do |session|
      coll = session[:daily_stats]

      coll.where(_id: id).update(updates)
    end
  end

  def total_for(event)
    stats.fetch_path(event, :total)
  end
end