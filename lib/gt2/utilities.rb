module Gt2::Utilities
  extend ActiveSupport::Concern

  module InstanceMethods
    def clean_event_params
      params
    end
  end
end