# This class takes a chart definition and produces a JSON object, usable by highcharts
#    [
#      {
#        name: 'Tokyo',
#        data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
#      }, {
#        name: 'New York',
#        data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
#      }, {
#        name: 'Berlin',
#        data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
#      }, {
#        name: 'London',
#        data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
#      }
#    ]
class Gt2::ChartRenderer
  def initialize(chart_config, app, options = {})
    @chart_config = chart_config
    @app          = app
    @options      = options
  end

  attr_reader :chart_config, :app, :options

  def data
    @data ||= fetch_data(options)
  end

  def categories
    # get a list of x-points from daily stats (dates)
    data.map { |ds| ds.date || 'N/A' }
  end

  def result
    # read line definitions (or expand helper definition)
    # for each line
    #   for each daily stat
    #     evaluate line
    expand_lines(chart_config.lines).map do |line|
      {
          name: line['name'],
          data: data.map { |ds| evaluate_formula(line['formula'], ds) },
      }
    end
  end

  private
  # returns data sorted chronologically
  def fetch_data(options = {})
    ndays = options[:ndays] || 30

    DailyStat.last_n(ndays, app.id).asc(:_id).to_a
  end

  def evaluate_formula(formula, daily_stat)
    vars = prepare_values(daily_stat)

    ev = Gt2::Evaluator.new(formula, prefer_current: daily_stat.today_record?)
    ev.evaluate_with(vars) { 0 } # return 0 for missing values
  end

  def prepare_values(daily_stat)
    definers = [Gt2::CommonValueDefiner, Gt2::AggregateValueDefiner, Gt2::CountedValueDefiner]
    definers.map{|klass| klass.new.call(daily_stat)}.reduce(&:merge)
  end

  def expand_lines(lines)
    Gt2::LineExpander.new.call(lines)
  end
end
