class WikiDocument

  attr_reader :author
  attr_accessor :title, :text

  def initialize(title, author, text)
    @title = title
    @author = author
    @text = text
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
