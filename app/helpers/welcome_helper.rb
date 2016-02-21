module WelcomeHelper
    def remember_musician
        params['musician'] ? params['musician'] : nil 
    end

    def remember_author
        params['author'] ? params['author'] : nil
    end
end
