Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  post 'sign_up', to: 'registration#sign_up'
  post 'auth', to: "auth#auth"
  post 'refresh', to: "auth#refresh_token"
  post 'category', to: 'categories#create'
  get 'categories', to: 'categories#index'
  put 'category', to: 'categories#udpate'
  delete 'category', to: 'categories#destroy'

  post 'picture', to: 'pictures#upload'
end
