class Gt2::ChartConfig
  def self.[](obj)
    defn_ary(obj).map{|defn| Gt2::ChartConfig.new(defn)}
  end

  def initialize(defn)
    @lines = defn["lines"]
    @format_string = defn["format_string"] || "{point.y}"
  end

  attr_reader :lines, :format_string

  private
  # we can't just call Array[obj], because it will turn nested hashes to arrays as well.
  def self.defn_ary(obj)
    return obj if obj.is_a?(Array)
    [obj]
  end
end