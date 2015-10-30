module BookDuetsHelper
  def tweetify(musician, author)
    current_page = request.original_url
    tweet = "Amazing text mashup of #{musician} and #{author} quotes! #{current_page}"
    tweet = tweet.gsub(" ", "%20")

    url = "https://twitter.com/intent/tweet?text=" + tweet + "&hashtags=bookduets"

    return url
  end
end
