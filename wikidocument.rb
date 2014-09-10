class WikiDocument

  attr_reader :author, :time
  attr_accessor :title, :text, :key, :id

  @@id = 1

  # TODO: Have author value filled in via login
  def initialize(title, author, text)
    @title = title
    @author = author
    @text = text
    @time = Time.new
    @id = @@id
    @key = "article:#{@id}"
    @@id += 1
  end

  # Override the json method to turn object into
  # a hash and then into json.
  def to_json
    article = {
      "key"     => key,
      "id"      => id,
      "title"   => title,
      "author"  => author,
      "text"    => text,
      "time"    => time
    }
    article.to_json
  end
end
