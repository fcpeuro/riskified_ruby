module Riskified
  MAJOR = 0
  MINOR = 1
  TINY = 0

  # Keep the original constants available for callers that referenced them.
  # standard:disable Naming/ConstantName
  Major = MAJOR
  Minor = MINOR
  Tiny = TINY
  # standard:enable Naming/ConstantName

  VERSION = "#{MAJOR}.#{MINOR}.#{TINY}"
end
