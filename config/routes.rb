Rails.application.routes.draw do
  
  # Keep these above the articles resources block
  match "m/a/toggle_feature/:id" => 'articles#toggle_feature', :as => :toggle_feature_articles
  match "m/a/approve/:id" => 'articles#approve', :as => :approve_articles
  match "m/a/toggle_publish/:id" => 'articles#toggle_publish', :as => :toggle_publish_articles
  match "a/review/" => 'articles#review', :as => :review_articles
  match "a/page/:page" => "articles#index"
  match "a/tagged/:tag" => 'articles#tagged', :as => :tagged_articles
    
  resources :articles do
    resources :comments, :only => [:create, :destroy]
  end

  root :to => "a#index"
end
