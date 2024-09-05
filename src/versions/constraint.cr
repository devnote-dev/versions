module Versions
  class Constraint
    getter req : Requirement
    getter version : SemanticVersion

    macro from(req, version)
      ::Versions::Constraint.new(::Versions::Requirement[{{req}}], {{version}})
    end

    # :nodoc:
    def initialize(@req : Requirement, @version : SemanticVersion)
    end

    def allows?(version : SemanticVersion) : Bool
      case @req
      in .gt?    then version > @version
      in .ge?    then version >= @version
      in .lt?    then version < @version
      in .le?    then version <= @version
      in .caret? then version.major <= @version.major
      in .tilde? then version.major <= @version.major && version.minor <= @version.minor
      end
    end

    def to_s(io : IO) : Nil
      @req.to_s io
      @version.to_s io
    end
  end
end
