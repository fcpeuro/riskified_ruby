module Riskified
module Statuses
  module StatusMixins
    def to_string
      self.class.name.split('::').last.downcase
    end
  end
end
end
