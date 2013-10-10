module AppsHelper
  def link_to_charts(app)
    if app && app.charts.present?
      link_to t('helpers.label.app.link'), app_stat_path(app)
    else
      I18n.t('messages.charts.not_found')
    end
  end
end
