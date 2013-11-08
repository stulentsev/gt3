class Gt2::CountedValueDefiner
  def call(daily_stat)
    daily_stat.counts.each_with_object({}) do |(k, cnts), vars|
      cnts.each do |subvalue, v|
        vars["#{k}.#{subvalue}.total"] = v['total']
      end
    end
  end
end