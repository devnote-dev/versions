module Versions
  enum Requirement
    Gt
    Ge
    Lt
    Le
    Caret
    Tilde

    macro [](op)
      {%
        unless op.is_a?(SymbolLiteral)
          raise "expected argument #1 to 'Versions::Constraint::Requirement.[]' to be SymbolLiteral, not #{op.class_name.id}"
        end
      %}
      {%
        name = {:> => :Gt, :>= => :Ge, :< => :Lt, :<= => :Le, :^ => :Caret, :~ => :Tilde}[op]
        op.raise "invalid version constraint requirement" unless name
      %}
      ::Versions::Requirement::{{name.id}}
    end

    def self.from(str : String) : self
      case str
      when ">"       then Gt
      when ">="      then Ge
      when "<"       then Lt
      when "<="      then Le
      when "^"       then Caret
      when "~", "~>" then Tilde
      else                raise ArgumentError.new "Invalid requirement operator"
      end
    end

    def to_s : String
      case self
      in Gt    then ">"
      in Ge    then ">="
      in Lt    then "<"
      in Le    then "<="
      in Caret then "^"
      in Tilde then "~"
      end
    end
  end
end
