class Gt2::NameScanner
  def initialize
    @name_regex = /\[[^\]]+\]/
  end

  def call(formula)
    formula.scan(@name_regex).flatten
  end
end