class Api::StatsController < Api::ApplicationController
  before_filter :verify_user_permission

  rescue_from StandardError, :with => :error_render_method

  def index
    chart = Chart.where(_id: params[:chart_id]).first

    options = {ndays: params[:ndays]}

    renderer = Gt2::ChartRenderer.new(chart, options)

    render_json categories: renderer.categories,
                data: renderer.result
  end

  private
  def verify_user_permission
    chart = Chart.where(_id: params[:chart_id]).first
    user = User.where(api_key: params[:api_key]).first

    unless chart && user && chart.app.user.id == user.id
      render_error('Authentication failed', 403)
    end
  end

  def error_render_method(ex)
    logger.error("API ERROR: #{ex}")
    ex.backtrace.each{|line| logger.error(line) }

    render_error "Oops", 500
  end
end