class Coercer
  def self.coerce(profile)
    profile.each_with_object({}) do |(key, value), acc|
      key_str = key.to_s
      if coercion_map[key_str]
        acc[key] = coercion_map[key_str].call(value)
      else
        acc[key] = value
      end
    end
  end

  # Define a method that returns the COERCION_MAP.
  # In subclasses, we can override this to provide a different map.
  def self.coercion_map
    {}
  end

  def self.array_of_strings_to_integers(array)
    array.map(&:to_i) if array.is_a?(Array)
  end
end