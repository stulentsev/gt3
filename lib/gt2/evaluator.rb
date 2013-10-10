class Gt2::Evaluator
  def initialize(formula = nil)
    self.formula = formula || ''

    @name_regex = /(((\w+)|(\[([^\.\]]+)\]))(\.\w+)?)/
  end

  attr_accessor :formula

  def used_names
    formula.scan(@name_regex).map(&:compact).map(&:first).map do |full_name|
      full_name.split('.').first
    end.uniq
  end

  def valid_formula?
    # scan for valid suffixes
    formula.scan(@name_regex).map(&:compact).map(&:first).map do |full_name|
      _, prefix = full_name.split('.')
      return false if prefix && !valid_prefix?(prefix)
    end

    # scan for names that don't conform to regex
    f = formula.gsub(@name_regex, '').gsub(/[\+\*\-\/]/, '')
    return false unless f.strip.empty?

    true
  end

  def evaluate_with(values)
    replaced = formula.gsub(@name_regex) do |match|
      name = match.gsub(/[\[\]]/, '')
      if is_number?(name)
        name
      else
        val = values[name]
        raise Gt2::Api::Errors::NotFoundError.new("Can not find value for variable #{name}") unless val
        val.to_f
      end
    end

    begin
      res = eval(replaced).round(2)

      return 0 if res.nan? || res == 1.0 / 0
      res == res.to_i ? res.to_i : res
    rescue Exception => ex
      Rails.logger.warn ex
      0
    end
  end

  def is_number?(str)
    !!Float(str)
  rescue TypeError, ArgumentError
    false
  end

  private
  def valid_prefix?(word)
    (%w{unique total sum average}.include?(word))
  end
end