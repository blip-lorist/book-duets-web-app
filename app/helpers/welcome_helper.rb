require 'uri'

module WelcomeHelper
    def remember_musician
        params['musician'] ? URI.decode(params['musician']) : nil
    end

    def remember_author
        params['author'] ? URI.decode(params['author']) : nil
    end
end
