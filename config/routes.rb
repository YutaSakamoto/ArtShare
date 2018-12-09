Rails.application.routes.draw do
  get 'crafts/index'
  get 'crafts/new'
  get 'crafts/create'
  get 'crafts/listing'
  get 'crafts/pricing'
  get 'crafts/description'
  get 'crafts/photo_upload'
  get 'crafts/location'
  get 'crafts/update'
  root 'pages#home'

  devise_for :users,
           path: '',
           path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
           controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :users, only: [:show] do
    member do
      patch '/update_phone_number' => 'users#update_phone_number'
    end
  end

  resources :crafts, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'location'
      get 'preload'
      get 'preview'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
    resources :calendars
  end
  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]

  get '/your_lendings' => 'reservations#your_lendings'
  get '/your_reservations' => 'reservations#your_reservations'
  post 'reservations/charge' => 'reservations#charge'

  get 'search' => 'pages#search'

  get 'dashboard' => 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
  post :charge, on: :member
  member do
    post '/approve' => "reservations#approve"
    post '/decline' => "reservations#decline"
  end
  end

  resources :conversations, only: [:index, :create]  do
  resources :messages, only: [:index, :create]
  end

  get '/host_calendar' => "calendars#host"
  get '/payment_method' => "users#payment"
  get '/payout_method' => "users#payout"
  post '/add_card' => "users#add_card"

  get '/notifications' => 'notifications#index'

  mount ActionCable.server => '/cable'

end
