class StatsController < ApplicationController
  before_filter :authenticate_user

  def show
    app = App.find(params[:app_id])

    chart = if params[:chart_id]
              app.charts.to_a.find{|c| c.id.to_s == params[:chart_id]}
            else
              app.charts.first
            end

    @presenter = StatPresenter.new(chart)
  end
end
