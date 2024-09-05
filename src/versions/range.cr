module Versions
  class Range
    getter! min : SemanticVersion
    getter! max : SemanticVersion
    getter? include_min : Bool
    getter? include_max : Bool

    def self.any : Range
      new nil, nil
    end

    def initialize(@min : SemanticVersion?, @max : SemanticVersion?, @include_min : Bool = false,
                   @include_max : Bool = false)
    end

    def includes?(version : SemanticVersion) : Bool
      if @min
        return false if version < min
        return false if !@include_min && version == min
      end

      if @max
        return false if version > max
        return false if !@include_max && version == max
      end

      true
    end

    def to_s(io : IO) : Nil
      if @min
        io << '>'
        io << '=' if @include_min
        @min.to_s io
      end

      if @max
        io << ", " if @min
        io << '<'
        io << '=' if @include_max
        @max.to_s io
      end

      io << '*' unless @min || @max
    end
  end
end
