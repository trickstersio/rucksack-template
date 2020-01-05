module Generators
  class Renderer
    class Values < OpenStruct
      def render(template)
        ERB.new(template).result(binding)
      end
    end

    def initialize(template_path)
      @template_path = template_path
    end

    def render(hash = {})
      Values.new(hash).render(template)
    end

    private def template
      return @template if defined?(@template)

      @template = File.read(@template_path)
      @template
    end
  end
end
