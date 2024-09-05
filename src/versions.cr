require "semantic_version"

require "./versions/constraint"
require "./versions/range"
require "./versions/requirement"

module Versions
  VERSION = "0.1.0"

  VERSION_RULE = /(?:(==?|>=?|<=?|\^|~>?)\s*)?((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(?:\+[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*)?)?/
  MATCH_REGEX  = /^#{VERSION_RULE}(?:(?:,\s*)?#{VERSION_RULE})?$/

  alias Version = Constraint | Range | SemanticVersion

  def self.parse(source : String) : Version
    unless match = MATCH_REGEX.match source
      raise ArgumentError.new "Invalid version requirement: #{source.inspect}"
    end

    if match[1]?
      req1 = Requirement.from match[1]
    end
    ver1 = SemanticVersion.parse match[2]

    if match[3]? && req1
      req2 = Requirement.from match[3]
      ver2 = SemanticVersion.parse match[4]

      if ver1 > ver2
        raise ArgumentError.new "Minimum version is greater than maximum version"
      end
      return ver1 if ver1 == ver2

      include_min = req1.ge? || req1.caret? || req1.tilde?
      include_max = req2.le? || req2.caret? || req2.tilde?

      Range.new ver1, ver2, include_min, include_max
    else
      if req1
        Constraint.new req1, ver1
      else
        ver1
      end
    end
  end
end
