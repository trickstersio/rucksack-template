module Generators
  class Base
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def generate!
      File.open(file_path, 'w') do |file|
        renderer = Generators::Renderer.new(template_path)
        file.write renderer.render(args)
      end
    end

    protected def template_path
      File.expand_path("#{self.class.name.deconstantize.underscore}/template.erb", LIB_PATH)
    end

    protected def args
      raise NotImplementedError, 'Generator must implement #args'
    end

    protected def file_path
      raise NotImplementedError, 'Generator must implement #file_path'
    end
  end
end
