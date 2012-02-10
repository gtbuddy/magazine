Rails.application.routes.draw do
  
  # Keep these above the articles resources block
  match "magazine/articles/toggle_feature/:id" => 'articles#toggle_feature', :as => :toggle_feature_articles
  match "magazine/articles/approve/:id" => 'articles#approve', :as => :approve_articles
  match "articles/review/" => 'articles#review', :as => :review_articles
  match "articles/feature/" => 'articles#feature', :as => :feature_articles
  match "articles/page/:page" => "articles#index"
  match "articles/tagged/:tag" => 'articles#tagged', :as => :tagged_articles
    
  resources :articles do
    resources :comments, :only => [:create, :destroy]
  end

  root :to => "articles#index"
end
