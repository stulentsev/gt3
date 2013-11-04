class ChartsController < InheritedResources::Base
  before_filter :authenticate_user

  def new
    new! do
      app = App.where(_id: params.fetch_path(:chart, :app_id)).first
      @events = events(app)
      @link_groups = prepare_links(@chart)
    end
  end

  def edit
    edit! do
      @events = events(@chart.app)
      @link_groups = prepare_links(@chart)
    end
  end

  def create
    create! { edit_app_path(@chart.app) }
  end

  def update
    update! do
      case params[:commit]
      when I18n.t("charts.edit.save")
        edit_app_path(@chart.app)
      when I18n.t("charts.edit.save_and_view")
        app_stat_path(@chart.app, chart_id: @chart.id)
      else
        raise "unexpected commit: #{params[:commit]}"
      end
    end
  end

  def destroy
    destroy! { edit_app_path(@chart.app) }
  end

  private
  def permitted_params
    params.permit(chart: [:name, :config, :app_id])
  end

  def prepare_links(chart)
    res = if chart.new_record?
            {}
          else
            {
              I18n.t('labels.links') => [
                {
                  name: I18n.t('labels.app'),
                  href: edit_app_path(chart.app)
                },
                {
                  name: I18n.t('labels.show_chart'),
                  href: app_stat_path(chart.app, chart_id: chart.id)
                },
              ]
            }
          end

    res.merge(
      I18n.t('labels.available_events') => @events.map { |e| { name: e, href: '' } }
    )
  end

  def events(app)
    return [] unless app

    app.app_events.map(&:name).sort
  end
end
