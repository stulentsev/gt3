class Gt2::AggregateValueDefiner
  def call(daily_stat)
    daily_stat.aggs.each_with_object({}) do |(k, v), vars|
      vars["#{k}.min"] = v['min']
      vars["#{k}.max"] = v['max']
      vars["#{k}.sum"] = sum = v['sum']

      cnt                  = v['count']
      vars["#{k}.average"] = sum.to_f / cnt

      cur = daily_stat.current_for(k)
      vars["#{k}.current"] = cur if cur
    end
  end
end