FactoryGirl.define do
  
  # =================
  # = Gem Factories =
  # =================
  factory :article, class: Blogit::Article do
    title "Tis is a blog article title"
    body "This is the body of the blog article - you'll see it's a lot bigger than the title"
    association :blogger, :factory => :user
  end
  
  factory :comment, class: Blogit::Comment do
    name "Gavin"
    email "gavin@gavinmorrice.com"
    website "http://gavinmorrice.com"
    body "I once saw a child the size of a tangerine!"
    article
  end
  
  # =======================
  # = Dummy App Factories =
  # =======================
  factory :user do
    username "bodacious"
    password "password"
  end
  
end