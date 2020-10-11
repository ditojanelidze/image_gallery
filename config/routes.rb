Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  post 'sign_up', to: 'registration#sign_up'
  post 'auth', to: "auth#auth"
  post 'refresh', to: "auth#refresh_token"
  post 'category', to: 'categories#create'
end
