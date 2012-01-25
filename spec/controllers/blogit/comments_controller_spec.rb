require 'spec_helper'

describe CommentsController do
  
  let(:article) { Blogit::Article.first || create(:article) }
    
  describe "POST create" do
    
    before do
      @comment_attributes = attributes_for(:comment)
    end
    
    def do_article(format = :html)
      article :create, article_id: article.id, 
        comment: @comment_attributes, use_route: :blogit, format: format
    end
    
    describe "whith JS" do
      
      it "should persist comment" do
        lambda { do_article(:js) }.should change { article.comments.count }.by(1)
      end
      
      # The rest is handled in the view
      
    end
    
    describe "with HTML" do
      
      it "should persist comment" do
        lambda { do_article(:html) }.should change { article.comments.count }.by(1)        
      end
      
      it "should redirect to the blog article" do
        do_article
        response.should redirect_to(controller.article_url(article))
      end

      it "should display a flash notice" do
        do_article
        flash[:notice].should be_present
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    def do_delete(format = :html)
      delete :destroy, id: @comment.id,
        article_id: article.id, format: format, use_route: :blogit
    end
    
    before do
      @comment  = create(:comment, article: article)  
    end
    
    describe "when user logged in" do

      before do
        mock_login
      end
            
      describe "whith JS" do
        
        it "should destroy the comment" do
          lambda { do_delete(:js) }.should change { article.reload.comments.count }
        end
        
      end

      describe "with HTML" do

        it "should destroy the comment" do
          lambda { do_delete(:html) }.should change { article.reload.comments.count }
        end

        it "should redirect to the blog article " do
          do_delete
          response.should redirect_to(controller.article_url(article))
        end

      end
      
    end
    
    describe "when user is not logged in" do
      
      
      describe "whith JS" do
        
        it 'should not destroy the comment' do
          lambda { do_delete }.should_not change { Comment.count }
        end
        
      end

      describe "with HTML" do

        it "should not destroy the comment" do
          lambda { do_delete }.should_not change { Comment.count }
        end

      end
      
    end
    
  end

end