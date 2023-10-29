class JsonSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    if hash == {}
      (hash || {}).with_indifferent_access
    else
      JSON.parse(hash || '{}').with_indifferent_access
    end
  end
end