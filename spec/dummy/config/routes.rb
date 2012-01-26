Rails.application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]

  mount Magazine::Engine => "/blog"
  
  resources :users  
  
  root :to => "magazine/articles#index"
  
end
