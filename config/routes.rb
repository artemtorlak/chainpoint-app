Rails.application.routes.draw do

  root to: redirect('/submit')

  get '/submit', to: 'badges#new'
  get '/success', to: 'badges#success'
  get '/error', to: 'badges#error'

  resources :badges do
    collection do
      get :new
      post :submit_to_chainpoint
      get :success
      get :error
    end
  end
end
