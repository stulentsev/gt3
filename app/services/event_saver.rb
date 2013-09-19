class EventSaver
  def initialize(event_params)
    @event_params = event_params.symbolize_keys
  end

  def valid?
    common_params_present? && contextual_params_present?
  end

  def save
    if valid?
      RawEntry.create(app_id: app_id, event_params: @event_params)

      # Collect all update operations and perform them at once, instead of firing several mongodb queries
      updates = update_common_parameters

      updates.deep_merge!(update_subvalue) if subvalue?
      updates.deep_merge!(update_numeric) if numeric?

      doc_id = "#{app_id}_#{Time.now.compact}"
      DailyStat.update_stats(doc_id, updates)

      'ok'
    else
      'error'
    end
  end

  def numeric?
    @event_params[:method] == 'track_number'
  end

  def subvalue?
    @event_params[:method] == 'track_value'
  end

  private
  def app_id
    @event_params.fetch(:app_id)
  end

  def event
    @event_params.fetch(:event)
  end

  def value
    @event_params.fetch(:value)
  end

  def user_id
    @event_params.fetch(:user_id)
  end

  def common_params_present?
    [:method, :app_id, :event].all?{|prm| @event_params.has_key?(prm)}
  end

  def contextual_params_present?
    if numeric? || subvalue?
      @event_params.has_key?(:value)
    else
      true
    end
  end

  def update_common_parameters
    Rails.configuration.redis_wrapper.add_event_unique(app_id, event, user_id)

    {
      :$inc => { "stats.#{event}.total" => 1 },
      :$set => { app_id: app_id, date: Time.now.compact }
    }
  end

  def update_subvalue
    {:$inc => {"counts.#{event}.total" => 1}}
  end

  def update_numeric
    { :$inc => { "aggs.#{event}.count" => 1,
                 "aggs.#{event}.sum"   => value.to_f
    } }

    # TODO: fire off a sidekiq job to set min/max
    # ds = find_daily_stat
    # Sidekiq.enqueue(:update_min, app_id: app_id, time: Time.now, event: event, min: value, cur_min: ds.min_for('event'))
  end
end