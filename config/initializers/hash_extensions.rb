class Hash
  def fetch_path(*parts)
    parts.reduce(self) do |memo, key|
      memo[key.to_s] if memo
    end
  end
end