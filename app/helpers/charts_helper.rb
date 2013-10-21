module ChartsHelper
  def chart_return_path(chart)
    if chart.app
      edit_app_path(chart.app)
    else
      profile_path
    end
  end
end
