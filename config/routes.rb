Rails.application.routes.draw do
  post 'sign_up', to: 'registration#sign_up'
end
