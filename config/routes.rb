Rails.application.routes.draw do
  devise_for :users

  resources :pizzas do
    resources :toppings, only: [:create, :destroy, :update]
  end
  
  resources :toppings
end
