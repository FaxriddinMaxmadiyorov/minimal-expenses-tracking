Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, path: '',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }


  resources :groups
  resources :users do
    member do
      get 'data', action: :report, as: :report
    end
  end

  get '/auth/:provider/callback' => 'sessions#omniauth'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
