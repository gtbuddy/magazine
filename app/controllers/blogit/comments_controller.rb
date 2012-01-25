module Blogit
  class CommentsController < ApplicationController

    blogit_authenticate :except => [:create]
    
    blogit_sweeper(:create, :update, :destroy)


    def create
      @comment = article.comments.new(params[:comment])
      respond_to do |format|
        format.js {
          # the rest is dealt with in the view
          @comment.save
        }

        format.html { 
          if @comment.save 
            redirect_to(article, :notice => "Successfully added comment!")
          else
            render "blogit/articles/show"
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
      @article ||= Blogit::Article.find(params[:article_id])
    end
    
  end
end
