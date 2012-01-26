module Magazine
  class CommentsController < ApplicationController

    magazine_authenticate :except => [:create]
    
    magazine_sweeper(:create, :update, :destroy)

		helper 'magazine/articles'

    def create

      @comment = article.comments.new(params[:magazine_comment])
      respond_to do |format|
        format.js {
          # the rest is dealt with in the view
          @comment.save
        }

        format.html { 
          if @comment.save 
            redirect_to(article, :notice => "Successfully added comment!")
          else
            render "magazine/articles/show"
          end
        }

      end

    end

    def destroy
      @comment = article.comments.find(params[:id])
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to(article, :notice => "Successfully removed comment.") }        
        format.js
      end
    end
    
    private

    def article
      @article ||= Magazine::Article.find(params[:magazine_article_id])
    end
    
  end
end
