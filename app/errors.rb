class Errors < Presenter
  def initialize(errors)
    @errors = errors
  end

  def as_json
    { errors: format(@errors) }
  end

  private def format(errors)
    errors.map do |key, messages|
      if messages.is_a? Hash
        [ key, format(messages) ]
      else
        [ key, Array(messages) ]
      end
    end.to_h
  end
end
