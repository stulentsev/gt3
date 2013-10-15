class Gt2::Evaluator
  def initialize(formula = nil)
    self.formula = formula || ''
  end

  attr_accessor :formula

  def used_names
    Gt2::NameScanner.new.call(formula).map do |full_name|
      Gt2::Utilities.strip_brackets(full_name).split('.').first
    end.uniq
  end

  def valid_formula?
    # scan for valid suffixes
    names = Gt2::NameScanner.new.call(formula)

    values = Hash[names.map{|n| [Gt2::Utilities.strip_brackets(n), 1]}]
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

  def is_number?(str)
    !!Float(str)
  rescue TypeError, ArgumentError
    false
  end

  private
  def valid_suffix?(word)
    (%w{unique total sum average}.include?(word))
  end

  def unsafe_evaluate_with(values, &block)
    replaced = Gt2::NameScanner.new.call(formula).reduce(formula) do |replaced, name|
      replacement = if is_number?(name)
                      name
                    else
                      stripped_name = Gt2::Utilities.strip_brackets(name)
                      val = values[stripped_name]

                      val ||= if block
                                block.call(stripped_name)
                              else
                                raise Gt2::Api::Errors::NotFoundError.new("Can not find value for variable #{stripped_name.inspect}") unless val
                              end

                      val.to_f
                    end
      replaced.gsub(name, replacement.to_s)
    end

    res = eval(replaced).round(2)

    return 0 if res.nan? || res == 1.0 / 0
    res == res.to_i ? res.to_i : res

  end
end