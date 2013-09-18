class EventSaver
  def initialize(event_params)
    @event_params = event_params
  end

  def valid?
    common_params_present? && contextual_params_present?
  end

  def save
    if valid?
      RawEntry.create(app_id: app_id, event_params: @event_params)
      'ok'
    else
      'error'
    end
  end

  private
  def app_id
    @event_params.fetch(:app_id)
  end

  def common_params_present?
    [:method, :app_id, :event].all?{|prm| @event_params.has_key?(prm)}
  end

  def contextual_params_present?
    case @event_params[:method].to_sym
    when :track_value, :track_number
      @event_params.has_key?(:value)
    else
      true
    end
  end
end