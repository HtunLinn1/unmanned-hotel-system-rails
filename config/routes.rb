Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root to: 'home#index'
  resources :bookings
  patch '/bookings/:id/paid', to: 'bookings#paid'
  patch '/bookings/:id/cancel', to: 'bookings#cancel'
  get '/bookings/history', to: 'bookings#history'
  delete '/bookings/:id/history-delete', to: 'bookings#historyDelete'
  delete '/bookings/:id/refund', to: 'bookings#refund'
  resources :rooms
  resources :faqs
  resources :users
  get '/facilities/index', to: 'facilities#index'
  get '/smartlocks/index', to: 'smartlocks#index'
  get '/inquiries/index', to: 'inquiries#index'
end
