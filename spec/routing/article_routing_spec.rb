require "spec_helper"

describe ArticlesController do
  
  describe "routing" do
    
    before do
      # Use magazine's routes instead
      @routes = Magazine::Engine.routes
    end
    
    it "routes /articles/page/:page to articles#index with page param" do
      { get: "articles/page/2" }.should route_to({
        controller: "magazine/articles",
        action: "index",
        page: "2"
      })
    end
    
    it "routes /articles/tagged/:tag to articles#tagged with tag param" do
      { get: "articles/tagged/Spiceworld" }.should route_to({
        controller: "magazine/articles",
        action: "tagged",
        tag: "Spiceworld"
      })      
    end


    describe "when Magazine.configuration.include_admin_actions is true" do

      before do
        Magazine.configuration.include_admin_actions = true
      end
      
    end

    describe "when Magazine.configuration.include_admin_actions is false" do

      before do
        Magazine.configuration.include_admin_actions = false 
      end

    end

  end
end
