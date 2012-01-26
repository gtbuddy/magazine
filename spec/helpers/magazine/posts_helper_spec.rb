require "spec_helper"

describe Magazine::ArticlesHelper do
  
  describe :article_tag do
    
    it "should create a tag element and give it a 'article... prefixed class" do
      helper.article_tag(:div, "hello", id: "blog_div", class: "other_class").should == %{<div class="other_class article_div" id="blog_div">hello</div>}
      helper.article_tag(:li, "hello", id: "blog_li").should == %{<li class="article_li" id="blog_li">hello</li>}      
    end
    
  end
  
end