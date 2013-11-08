class Gt2::CommonValueDefiner
  def call(daily_stat)
    daily_stat.stats.each_with_object({}) do |(k, v), vars|
      vars["#{k}.total"]  = v['total']
      vars["#{k}.unique"] = v['unique']
    end
  end
end