module Sessions
  module Actions
    class Create < Action
      attr_reader :session

      schema do
        required(:kind) { filled? & str? }
        required(:credentials) { hash? }
      end

      def initialize(args = {})
        super(nil, args)
      end

      def execute!
        @session = Sessions::Owners.for(inputs[:kind]).authenticate(inputs[:credentials])

        if @session.nil?
          fail!(errors: { base: "Your credentials are wrong" })
          return
        end

        success!
      end
    end
  end
end
