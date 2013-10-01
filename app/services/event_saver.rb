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

      doc_id = "#{app_id}_#{time.compact}"
      DailyStat.update_stats(doc_id, updates)

      # Update redis cache for min/max values (to be flushed later in background)
      update_minmax_caches if numeric?

      update_dau
      update_mau

      create_app_event

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
  def time
    @time ||= Time.now
  end

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
      :$set => { app_id: app_id, date: time.compact }
    }
  end

  def update_subvalue
    {:$inc => {"counts.#{event}.total" => 1}}
  end

  def update_numeric
    { :$inc => { "aggs.#{event}.count" => 1,
                 "aggs.#{event}.sum"   => value.to_f
    } }
  end

  def update_minmax_caches
    Rails.configuration.redis_wrapper.set_min_value(app_id, event, value)
    Rails.configuration.redis_wrapper.set_max_value(app_id, event, value)
  end

  def update_dau
    Rails.configuration.redis_wrapper.add_dau(app_id, user_id)
  end

  def update_mau
    Rails.configuration.redis_wrapper.add_mau(app_id, user_id)
  end

  def create_app_event
    ae_id = "#{app_id}:#{event}"
    AppEvent.where(_id: ae_id, app_id: app_id, name: event).first_or_create!
  end
end