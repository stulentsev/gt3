class DailyStat
  include Mongoid::Document

  field :app_id, type: String
  field :date, type: String

  field :stats, type: Hash, default: {}
  field :counts, type: Hash, default: {}
  field :aggs, type: Hash, default: {}

  scope :today_stat, ->(app_id) { where(_id: "#{app_id}_#{Time.now.compact}") }

  def self.update_stats(id, updates)
    # Use moped session directly to update multiple field atomically

    # session[:artists].find(name: "Syd Vicious").update(:$push => { instruments: { name: "Bass" }})
    Mongoid::Sessions.default.with do |session|
      coll = session[:daily_stats]

      coll.where(_id: id).upsert(updates)
    end
  end

  def total_count_for(event)
    stats.fetch_path(event, :total)
  end

  def unique_count_for(event)
    stats.fetch_path(event, :unique)
  end

  def subvalue_total_count_for(event, subvalue)
    counts.fetch_path(event, subvalue, :total)
  end
end