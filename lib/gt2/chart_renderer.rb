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
  def initialize(chart)
    @chart = chart
    @data = fetch_data
  end

  attr_reader :chart

  def categories
    # get a list of x-points from daily stats (dates)
    @data.map(&:date)
  end

  def result
    # read line definitions (or expand helper definition)
    # for each line
    #   for each daily stat
    #     evaluate line
    chart.lines.map do |line|
      {
        name: line['name'],
        data: @data.map{|ds| evaluate_formula(line['formula'], ds)},
      }
    end
  end

  private
  # returns data sorted chronologically
  def fetch_data
    DailyStat.last_30(chart.app.id).asc(:_id).to_a
  end

  def evaluate_formula(formula, daily_stat)
    v1 = common_values(daily_stat)
    v2 = agg_values(daily_stat)
    v3 = counted_values(daily_stat)

    vars = v1.merge(v2).merge(v3)

    ev = Gt2::Evaluator.new(formula)
    ev.evaluate_with(vars) { 0 } # return 0 for missing values
  end

  def counted_values(daily_stat)
    daily_stat.counts.each_with_object({}) do |(k, cnts), vars|
      cnts.each do |subvalue, v|
        vars["#{k}.#{subvalue}.total"] = v['total']
      end
    end
  end

  def agg_values(daily_stat)
    daily_stat.aggs.each_with_object({}) do |(k, v), vars|
      vars["#{k}.min"] = v['min']
      vars["#{k}.max"] = v['max']
      vars["#{k}.sum"] = sum = v['sum']

      cnt                  = v['count']
      vars["#{k}.average"] = sum.to_f / cnt
    end
  end

  def common_values(daily_stat)
    daily_stat.stats.each_with_object({}) do |(k, v), vars|
      vars["#{k}.total"]  = v['total']
      vars["#{k}.unique"] = v['unique']
    end
  end
end
