Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  post 'sign_up',        to: 'registration#sign_up'
  post 'auth',           to: "auth#auth"
  post 'refresh',        to: "auth#refresh_token"

  post 'category',       to: 'categories#create'
  get 'categories',      to: 'categories#index'
  put 'category/:id',    to: 'categories#update'
  delete 'category/:id', to: 'categories#destroy'

  post 'picture',        to: 'pictures#upload'
  delete 'picture/:id',  to: 'pictures#remove'
  get 'pictures',        to: 'pictures#index'
  post 'attach_similar', to: 'pictures#attach_similar'
end
