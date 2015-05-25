Rails.application.routes.draw do
  root to: "home#index"
  get 'jump', to: 'home#jump'
end
