class Gt2::Evaluator
  def initialize(formula = nil, options = {})
    self.formula = formula || ''
    @prefer_current = options[:prefer_current]
  end

  attr_accessor :formula

  def prefer_current?
    @prefer_current
  end

  def used_names
    Gt2::NameScanner.new.call(formula).map do |full_name|
      Gt2::Utilities.strip_brackets(full_name).split('.').first
    end.uniq
  end

  def valid_formula?
    # scan for valid suffixes
    names = Gt2::NameScanner.new.call(formula)

    values = Hash[names.map { |n| [Gt2::Utilities.strip_brackets(n), 1] }]
    begin
      unsafe_evaluate_with(values)
      true
    rescue => ex
      false
    end
  end

  def evaluate_with(values, &block)
    begin
      unsafe_evaluate_with(values, &block)
    rescue Gt2::Api::Errors::NotFoundError
      raise
    rescue => ex
      Rails.logger.warn ex
      0
    end
  end

  private
  def unsafe_evaluate_with(values, &block)
    replaced = Gt2::NameScanner.new.call(formula).reduce(formula) do |replaced, name|
      replacement = get_replacement(name, values, block)
      replaced.gsub(name, replacement.to_s)
    end

    res = eval(replaced).round(2)

    return 0 if res.nan? || res == 1.0 / 0
    res == res.to_i ? res.to_i : res

  end

  def get_replacement(name, values, block)
    stripped_name = massage_name(Gt2::Utilities.strip_brackets(name))
    val           = values[stripped_name] || handle_missing_value(stripped_name, block)
    val.to_f
  end

  def handle_missing_value(stripped_name, block)
    if block
      block.call(stripped_name)
    else
      raise Gt2::Api::Errors::NotFoundError.new("Can not find value for variable #{stripped_name.inspect}")
    end
  end

  # transforms name like open_rooms.current(max) to open_rooms.current
  def massage_name(name)
    tr = Gt2::NameTransformer.new(name)

    if prefer_current?
      tr.current
    else
      tr.source_attribute
    end
  end
end