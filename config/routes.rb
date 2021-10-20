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
  resources :rooms
end
