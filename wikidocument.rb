class WikiDocument

  attr_reader :author
  attr_accessor :title, :text

  # TODO: Have author value filled in via login
  def initialize(title, author, text)
    @title = title
    @author = author
    @text = text
    @time = Time.new
  end

  # Override the json method to turn object into
  # a hash and then into json.
  def to_json
    article = {
      "title"   => title,
      "author"  => author,
      "text"    => text
    }
    article.to_json
  end

end
