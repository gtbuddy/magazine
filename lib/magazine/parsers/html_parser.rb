class Magazine::Parsers::HtmlParser

  attr_reader :parsed

  def initialize(content)
    @parsed = content
  end

end  
