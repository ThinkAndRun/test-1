Rails.application.routes.draw do
  root 'calculator#index'
  get 'calculator/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
