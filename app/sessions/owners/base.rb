module Sessions
  module Owners
    class Base
      def self.inherited(subclass)
        subclass.const_set("KIND", subclass.name.underscore)
      end
    end
  end
end
