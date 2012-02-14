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
        @articles = Article.public.for_index(page)
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
    @article = current_blogger.articles.new(params[:magazine_article])
  end

  def edit
    @article = current_blogger.articles.find(params[:id])
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
    @article = current_blogger.articles.find(params[:id])
    if @article.update_attributes(params[:magazine_article])
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
      redirect_to review_magazine_articles_path, :notice => 'Article was successfully approved.'
    else
      redirect_to review_magazine_articles_path, :notice => 'Article was not successfully approved.'
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

  def set_reviewed
    @article = Article.find(params[:id])
    if @article.reviewed
      redirect_to :back , :notice => 'Article was successfully reviewed.'
    else
      redirect_to :back , :notice => 'Article was not successfully reviewed.'
      end
    end

    private

    def raise_404
      # Don't include admin actions if include_admin_actions is false
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
    end

  end

end
