Rails.application.routes.draw do

  root 'companies#home'

  resources :companies, only: [:index] do
    resources :operations, only: []do
      get "for_company", on: :collection
      get "csv_for_company", on: :collection
    end
  end

  resources :operations ,only: []do
    post "import", on: :collection
  end

end
