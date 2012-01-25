module Blogit
    
  class ArticlesController < ApplicationController

    unless blogit_conf.include_admin_actions
      before_filter :raise_404, :except => [:index, :show, :tagged]
    end

    blogit_authenticate(:except => [:index, :show, :tagged])
    
    blogit_cacher(:index, :show, :tagged)
    blogit_sweeper(:create, :update, :destroy)

    def index
      respond_to do |format|
        format.xml {
          @articles = Article.order('created_at DESC')
        }
        format.html {
					page = params[:page] || 1
          @articles = Article.for_index(page)
        }
        format.rss {
          @articles = Article.order('created_at DESC')
        }
      end
    end

    def show
      @article    = Article.find(params[:id])
      @comment = @article.comments.new
    end

    def tagged
			page = params[:page] || 1
      @articles = Article.for_index(page).tagged_with(params[:tag])
      render :index
    end

    def new
      @article = current_blogger.articles.new(params[:article])
    end

    def edit
      @article = current_blogger.articles.find(params[:id])
    end

    def create
      @article = current_blogger.articles.new(params[:article])
      if @article.save
        redirect_to @article, :notice => 'Article was successfully created.'
      else
        render :action => "new"
      end
    end

    def update
      @article = current_blogger.articles.find(params[:id])
      if @article.update_attributes(params[:article])
        redirect_to @article, :notice => 'Article was successfully updated.'
      else
        render :action => "edit"
      end
    end

    def destroy
      @article = current_blogger.articles.find(params[:id])
      @article.destroy
      redirect_to articles_url, :notice => "Article was successfully destroyed."
    end

    private

    def raise_404
      # Don't include admin actions if include_admin_actions is false
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
    end

  end

end