Rails.application.routes.draw do
  resources :gift_cards, only: [:show, :new, :create]
  get 'gift_cards/:id/pay', to: 'gift_cards#pay', as: :gift_cards_pay
  get 'gift_cards/:id/confirm_payment', to: 'gift_cards#confirm_payment', as: :gift_cards_payment_confirm
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
