Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, path: '',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }

  resources :expenses
  # do
  #   member do
  #     get 'download', action: :download, as: :download
  #     get 'preview', action: :preview, as: :preview
  #   end

  resources :users do
    member do
      get 'data', action: :report, as: :report
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
