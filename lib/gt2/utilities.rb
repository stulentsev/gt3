module Gt2::Utilities
  def self.strip_brackets(name)
    name.gsub(/[\[\]]/, '')
  end
end