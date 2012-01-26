xml.instruct! 
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do 

  for article in @articles
    xml.url do
      xml.loc article_url(article)
      xml.lastmod article.updated_at.xmlschema
    end
  end
  
end