module Versions
  # :nodoc:
  class Union
    getter versions : Array(Version)

    def self.of(*versions : Union | Version) : Union
      of ranges
    end

    def self.of(versions : Enumerable(Union | Version)) : Union
      all = [] of Version

      versions.each do |version|
        if version.is_a? Union
          all.concat version.versions
        else
          all << version
        end
      end

      new all
    end

    def initialize(@versions : Array(Version))
    end

    def includes?(version : SemanticVersion) : Bool
      @versions.each do |ver|
        case ver
        in Constraint
          return true if ver.allows? version
        in Range
          return true if ver.includes? version
        in SemanticVersion
          return true if ver == version
        end
      end

      false
    end
  end
end
