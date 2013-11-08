class StatPresenter
  include Rails.application.routes.url_helpers

  def initialize(chart)
    @chart    = chart
    yaml_config = YAML.load(chart.config)
    @configs = Gt2::ChartConfig.get_array(yaml_config)
  end

  attr_reader :chart

  def each_chart(&block)
    @configs.each do |conf|
      renderer = Gt2::ChartRenderer.new(conf, @chart.app, ndays: ndays)
      proxy = OpenStruct.new(
          categories: format_dates(renderer.categories),
          chart_data: renderer.result,
          uuid: SecureRandom.hex,
          format_string: conf.format_string,
          chart_name: chart.name
      )
      block.call(proxy)
    end
  end

  def sidebar_links
    {
      I18n.t('labels.links')  => app_related_links,
      I18n.t('labels.charts') => app_chart_links,
    }
  end

  def app
    chart.app
  end

  def ndays
    chart.app.user.ndays
  end

  def chart_first_event
    line = @configs.first.lines.first
    formula = line['formula']
    ev = Gt2::Evaluator.new(formula)
    ev.used_names.first || 'load_app'
  end

  private
  def format_dates(arr)
    arr.map do |elem|
      d = Date.parse(elem)
      d.strftime('%b %d')
    end
  end


  def app_related_links
    [
      {
        name: I18n.t('labels.app'),
        href: edit_app_path(app)
      },
      {
        name: I18n.t('charts.edit.edit'),
        href: edit_chart_path(chart)
      },
    ]
  end

  def app_chart_links
    links = app.charts.map { |c| {name: c.name, href: app_stat_path(app, chart_id: c.id.to_s) } }
    links.sort_by{|h| h[:name]}
  end

end