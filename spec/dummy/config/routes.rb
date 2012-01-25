Rails.application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]

  mount Blogit::Engine => "/blog"
  
  resources :users  
  
  root :to => "blogit/articles#index"
  
end
