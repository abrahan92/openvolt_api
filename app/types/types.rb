module Types
  include Dry.Types()

  StrToBool = Types::Bool.constructor do |value|
    case value
    when 'true' then true
    when 'false' then false
    else value
    end
  end

  StrToInt = Dry::Types['coercible.integer'].constructor do |value|
    String === value ? value.to_i : value
  end

  StrArrayToIntArray = Types::Array.constructor do |value|
    if value.is_a?(Array)
      value.map do |el|
        if String === el
          el.to_i
        else
          el
        end
      end
    else
      value
    end
  end

  StrToTime = Types::String.constructor do |value|
    String === value ? value : value.to_s
  end
end