Rails.application.routes.draw do
  resources :books do
    resources :notes do
      member do
        put 'export'
      end
    end
    member do
      put 'export'
    end
    collection do
      put 'export_all'
    end
  end
  #put '/books/export_all', to: 'books#export_all', as: 'export_all_books'

  #do
  #   member do
  #     get :rename
  #     put :update_rename
  #   end
  # end
  devise_for :users
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "home#index"

end
