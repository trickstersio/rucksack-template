module Sessions
  class Session
    def self.for(kind, owner)
      Sessions::Session.new(token(kind, owner))
    end

    def self.token(kind, owner, timestamp: Time.now)
      payload = {
        uuid: SecureRandom.uuid,
        owner: Sessions::Owners.for(kind).serialize(owner),
        timestamp: timestamp.utc.iso8601,
        kind: kind
      }

      Base64.urlsafe_encode64(
        JWT.encode(payload, Application.configuration.session_secret, 'HS256')
      )
    end

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def timestamp
      Time.parse(payload[:timestamp]).utc
    rescue
      nil
    end

    def kind
      @kind ||= payload[:kind]
    end

    def owner
      @owner ||= Sessions::Owners.for(kind).deserialize(payload[:owner])
    end

    def payload
      return @payload if defined?(@payload)

      begin
        @payload = JWT.decode(Base64.urlsafe_decode64(@token), secret, true, algorithm: 'HS256')[0]
        @payload.deep_symbolize_keys! if @payload.present?
      rescue StandardError
        {}
      end
    end

    private def secret
      Application.configuration.session_secret
    end
  end
end
