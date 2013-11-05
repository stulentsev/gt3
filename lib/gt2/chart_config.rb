class Gt2::ChartConfig
  def self.from_chart(chart)
    definitions = defn_ary(YAML.load(chart.config))

    definitions.map{|defn| Gt2::ChartConfig.new(defn)}
  end

  def initialize(defn)
    @lines = defn["lines"]
    @format_string = defn["format_string"] || "{point.y}"
  end

  attr_reader :lines, :format_string

  private
  def self.defn_ary(obj)
    return obj if obj.is_a?(Array)
    [obj]
  end
end