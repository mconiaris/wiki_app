module ApplicationHelper

  ########################
  # Methods
  ########################

  # Takes in Markdown text and returns HTML
  def render_to_html(text)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
        :fenced_code_blocks => true,
        :hard_wrap => true
        )
    # binding.pry
    @rendered_text = markdown.render(text)
  end

  # Create a list of all documents/articles
  def generate_documents_array
    @documents = []
    $redis.keys("*article:*").each do |key|
      document = get_document_from_redis(key)
      @documents.push(document)
    end
    @documents.sort_by! { |hsh| hsh["id"]}
    @documents.reverse!
    # binding.pry
  end

  # Get article from redis and turn it in
  # to a hash
  def get_document_from_redis(key)
    raw_data = $redis.get(key)
    JSON.parse(raw_data)
    # binding.pry
  end

  def add_document_to_redis(doc)
    # binding.pry
    $redis.set(doc.key, doc.to_json)
  end

  def find_article(params)
    documents = generate_documents_array
    documents.each do |doc|
      if doc["title"] == "##{params[:id]}"
        return doc
      end
    end
  end

end
