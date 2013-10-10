class StatsController < ApplicationController
  def show
    @app = App.find(params[:app_id])

    @chart = if params[:chart_id]
              @app.charts.to_a.find{|c| c.id.to_s == params[:chart_id]}
            else
              @app.charts.first
            end

    if @chart
      renderer = Gt2::ChartRenderer.new(@chart)
      @categories = renderer.categories
      @chart_data = renderer.result

      @link_groups = {
        I18n.t('labels.links') => app_related_links,
        I18n.t('labels.charts') => app_chart_links,
      }
    else
      @chart = OpenStruct.new(name: I18n.t('messages.charts.not_found'))
      @categories = []
      @chart_data = []
      @link_groups = {}
    end
  end

  private
  def app_related_links
    [
      {
        name: I18n.t('labels.app'),
        href: edit_app_path(@app)
      }
    ]
  end

  def app_chart_links
    @app.charts.map { |c| { name: c.name, href: app_stat_path(@app, chart_id: c.id.to_s) } }
  end
end
