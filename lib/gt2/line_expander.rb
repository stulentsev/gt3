class Gt2::LineExpander
  def call(lines_obj, &block)
    case lines_obj
      when Array
        lines_obj
      when String
        @counted_values = block.call
        expand_lines_from_string(lines_obj)
      else
        raise "Unrecognized lines_format: #{lines_obj.inspect}"
    end
  end

  attr_reader :counted_values

  private
  def expand_lines_from_string(lines_helper)
    event_name, function, num = Gt2::Utilities.strip_brackets(lines_helper).split(/[\.\(\)]/)
    num                       = num.to_i

    subeevent_names = name_subset(event_name, function, num)

    subeevent_names.map do |subname|
      {
          "name"    => subname,
          "formula" => "[#{event_name}.#{subname}.total]",
      }
    end
  end

  def name_subset(event, function, num)
    return [] if counted_values.blank?

    val = counted_values[event] || {}
    subnames_with_counts = val.map { |k, v| [k, v["total"]] }.sort_by { |_, b| b }.map(&:first)

    case function
      when "top"
        subnames_with_counts.last(num)
      when "bottom"
        subnames_with_counts.first(num)
      else
        raise "Undefined function #{function.inspect} for lines_helper"
    end
  end

end