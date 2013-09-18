module CompactTimeFormat
  extend ActiveSupport::Concern

  def compact
    strftime('%Y%m%d')
  end
end

Time.send :include, CompactTimeFormat
Date.send :include, CompactTimeFormat
