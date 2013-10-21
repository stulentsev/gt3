class Gt2::NameTransformer
  REGEX = /\.current\((?<attr>\w+)\)$/

  def initialize(name)
    @name = name
  end

  def current
    @name.sub(REGEX, '.current')
  end

  def source_attribute
    if(m = @name.match(REGEX))
      @name.sub(REGEX, '.' + m['attr'])
    else
      @name
    end
  end
end