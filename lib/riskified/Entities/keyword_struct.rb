# frozen_string_literal: true

module Riskified
  module Entities
    class KeywordStruct < Struct
      def initialize(**kwargs)
        super(kwargs.keys)
        kwargs.each {|k, v| self[k] = v}
      end
    end
  end
end

