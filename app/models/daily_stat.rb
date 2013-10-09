class DailyStat
  include Mongoid::Document

  field :app_id, type: String
  field :date, type: String

  field :stats, type: Hash, default: {}
  field :counts, type: Hash, default: {}
  field :aggs, type: Hash, default: {}

  scope :today_stat, ->(app_id) { where(_id: "#{app_id}_#{Time.now.compact}") }
  scope :last_30, ->(app_id) {
    first_id = "#{app_id}_#{30.days.ago.compact}"
    today_id = "#{app_id}_#{Time.now.compact}"
    where(:_id.gte => first_id, :_id.lte => today_id)
  }

  def self.update_stats(id, updates)
    return if updates.empty?

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
    if today_record?
      Rails.configuration.redis_wrapper.get_event_uniques(app_id, event)
    else
      stats.fetch_path(event, :unique)
    end
  end

  def subvalue_total_count_for(event, subvalue)
    counts.fetch_path(event, subvalue, :total)
  end

  def sum_for(event)
    aggs.fetch_path(event, :sum)
  end

  def avg_for(event)
    cnt = aggs.fetch_path(event, :count)
    sum = sum_for(event)

    sum / cnt
  end

  def min_for(event)
    aggs.fetch_path(event, :min)
  end

  def max_for(event)
    aggs.fetch_path(event, :max)
  end

  private
  def today_record?
    _id =~ /.*_#{Time.now.compact}/
  end
end