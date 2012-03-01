module Magazine

  class ArticlesController < ApplicationController

    unless magazine_conf.include_admin_actions
      before_filter :raise_404, :except => [:index, :show, :tagged]
    end

    magazine_authenticate(:except => [:index, :show, :tagged])

    magazine_authenticate_admin(:only => [:review, :feature, :toggle_feature, :approve, :toggle_publish, :set_reviewed])

    magazine_cacher(:index, :show, :tagged)
    magazine_sweeper(:create, :update, :destroy)

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
      @article = current_blogger.articles.build(params[:magazine_article])
    end

    def edit
      @article    = Article.find(params[:id])
      if current_blogger.admin? or current_blogger.id == @article.blogger_id
        return true
      else
        redirect_to :back, :notice => 'Only admin or post\'s author is allowed to edit articles.'
      end
    end

    def create
      @article = current_blogger.articles.new(params[:magazine_article])
      if @article.save
        redirect_to @article, :notice => 'Article was successfully created.'
      else
        render :action => "new"
      end
    end

    def update
      @article = Article.find(params[:id])
      if @article.update_attributes(params[:magazine_article])
        redirect_to @article, :notice => 'Article was successfully updated.'
      else
        render :action => "edit"
      end
    end

    def destroy
      @article = Article.find(params[:id])
      @article.destroy
      redirect_to magazine_url, :notice => "Article was successfully destroyed."
    end

    def review
      @articles = Article.all
    end

    def toggle_feature
      @article = Article.find(params[:id])
      if @article.toggle_feature
        featured = @article.featured ? 'featured' : 'unfeatured.'
        redirect_to :back, :notice => 'Article was successfully ' + featured
      else
        redirect_to :back, :notice => 'Article was not successfully ' + featured 
      end
    end

    def approve
      @article = Article.find(params[:id])
      if @article.approve
        @article.toggle_publish if @article.published == false
        if request.referer.include? 'review'
          @review = true 
          @articles = Article.all
        end
        respond_to do |format|
          format.html
          format.js{}
        end
      else
        redirect_to :back, :notice => 'Article was not successfully approved.'
      end
    end

    def toggle_publish
      @article = Article.find(params[:id])
      if @article.toggle_publish
        published = @article.published ? 'published' : 'unpublished.'
        redirect_to :back , :notice => 'Article was successfully ' + published 
      else
        redirect_to :back , :notice => 'Article was not successfully ' + published
      end
    end

    private

    def raise_404
      # Don't include admin actions if include_admin_actions is false
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
    end

  end

end
