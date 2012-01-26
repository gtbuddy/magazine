require 'spec_helper'

describe ArticlesController do
  
  before do
    reset_configuration
  end

  let(:article) { build :article }

  describe "GET 'index'" do

    let(:articles) { [] }
    
    def do_get(page=nil)
      get :index, :use_route => :magazine, page: page.to_s
    end
    
    it "should set articles to Magazine::Article.for_index" do
      Magazine::Article.expects(:for_index).returns(articles)
      do_get
      assigns(:articles).should == articles
    end
    
    it "should pass the page param to for_index" do
      Magazine::Article.expects(:for_index).with("2").returns(articles)
      do_get("2")
      assigns(:articles).should == articles
    end
    
  end
  
  describe "GET /index.xml" do
    

    let(:articles) { [] }
    
    def do_get(page=nil)
      get :index, :use_route => :magazine, page: page.to_s, format: :xml
    end
    
    it "should load all articles in reverse date order" do
      Magazine::Article.expects(:order).with('created_at DESC').returns(articles)
      do_get
      assigns(:articles).should == articles
    end
    
  end
  
  describe "GET 'new'" do
    
    context "when logged in" do
      
      before do
        mock_login
      end
      
      def do_get
        get :new, use_route: :magazine
      end
    
      it "should be successful" do
        do_get
        response.should be_success
      end
      
      it "should set article to a new blog article" do
        do_get
        assigns(:article).should be_a(Magazine::Article)
        assigns(:article).should be_a_new_record
      end
      
    end
    
    context "when not logged in" do
      
      def do_get
        get :new, use_route: :magazine
      end
      
      # It's not really the responsibility of the gem to manage authentication 
      # so testing for specific behaviour here is not required
      # at the very least though, we'd expect the status not to be 200
      it "should redirect to another page" do
        do_get
        response.should_not be_success
      end
      
    end
  end
  
  describe "POST /create" do
    
    context "when logged in" do
      
      before do
        mock_login
      end
      
      context "with valid params" do
        
        let(:article_attributes) { attributes_for(:article) }
        
        def do_article
          article :create, use_route: :magazine, article: article_attributes
        end
        
        before do
          @articles = []
          @current_blogger.expects(:articles).returns(@articles)
          @articles.expects(:new).with(article_attributes.stringify_keys).returns(article)
          article.expects(:save).returns(true)
        end
                
        it "should redirect to the blog article page" do
          do_article
          response.should redirect_to(controller.articles_url)
        end
        
      end
      
    end
    
  end

  
  describe "GET 'edit'" do
    
    context "when logged in" do
            
      before do
        mock_login
        @current_blogger.expects(:articles).returns(@articles = [])
        @articles.expects(:find).with("1").returns(article)
      end
      
      def do_get
        get :edit, :id => 1, use_route: :magazine
      end
      
      it "should find the blog article by the ID" do
        do_get
        assigns(:article).should eql(article)
      end
      
    end
    
    context "when not logged in" do
      
      def do_get
        get :edit, :id => 1, use_route: :magazine
      end
      
      # It's not really the responsibility of the gem to manage authentication 
      # so testing for specific behaviour here is not required
      # at the very least though, we'd expect the status not to be 200
      it "should redirect to another pages" do
        do_get
        response.should_not be_success
      end
      
    end

  end
  
  describe "PUT 'update'" do
        
    context "when logged in" do
      
      before do
        @article_attributes = { "title" => "Something new" }
        mock_login
        @current_blogger.expects(:articles).returns(@articles = [])
        @articles.expects(:find).with("1").returns(article)
      end
      
      def do_put
        put :update, id: "1", use_route: :magazine, article: @article_attributes
      end
      
      it "should update the article attributes from params" do
        article.expects(:update_attributes).with(@article_attributes).returns(true)
        do_put
      end
      
      it "should redirect to the blog article page" do
        do_put
        response.should redirect_to(controller.article_url(article))
      end
      
      it "should set a flash notice" do
        do_put
        flash[:notice].should be_present
      end
    end
    
    context "when not logged in" do
      
      before do
        @article_attributes = { "title" => "Something new" }
      end
      
      def do_put
        put :update, id: "1", use_route: :magazine, article: @article_attributes
      end
      
      # It's not really the responsibility of the gem to manage authentication 
      # so testing for specific behaviour here is not required
      # at the very least though, we'd expect the status not to be 200
      it "should redirect to another page" do
        do_put
        response.should_not be_success
      end
      
    end
    
  end
  
  describe "GET 'show'" do
      
    before do
      Magazine::Article.expects(:find).with("1").returns(article)
    end
    
    def do_get
      get :show, :id => 1, use_route: :magazine
    end
    
    it "should find blog article by id" do
      do_get
      assigns(:article).should eql(article)
    end

  end
  
  describe "DELETE 'destroy'" do
        
    def do_delete
      delete :destroy, id: "1", use_route: :magazine
    end
    
    describe "when logged in" do
            
      before do
        mock_login
        @current_blogger.expects(:articles).returns(@articles = [])
        @articles.expects(:find).with("1").returns(article)
      end
      
      it "should destroy the blog article" do
        article.expects(:destroy)
        do_delete
      end
      
      it "should redirect to the blog articles url" do
        do_delete
        response.should redirect_to(controller.articles_url)
      end
      
      it "should show a flash notice" do
        do_delete
        flash[:notice].should be_present
      end
      
    end
    
    describe "when not logged in" do
      
      it "should redirect to another page" do
        do_delete
        response.should_not be_success
      end
      
    end
    
  end

end