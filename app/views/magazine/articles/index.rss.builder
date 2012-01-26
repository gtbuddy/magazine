xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    
    xml.title magazine_conf.rss_feed_title
    
    xml.description magazine_conf.rss_feed_description
    
    xml.pubDate CGI.rfc1123_date @articles.first.try(:updated_at)
    
    xml.link root_url
    
    xml.lastBuildDate CGI.rfc1123_date @articles.first.try(:updated_at)
    
    xml.language magazine_conf.rss_feed_language
    
    @articles.each do |article|
    
      xml.item do
        xml.title article.title
        xml.description format_content(truncate(article.body, :length => 400)).html_safe
        xml.link article_url(article)
        xml.pubDate CGI.rfc1123_date(article.updated_at)
        xml.guid article_url(article)
        xml.author article.blogger_display_name
      end
    
    end
  end
end
