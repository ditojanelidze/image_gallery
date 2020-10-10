require 'swagger_helper'

describe 'Registration Service' do

  path '/sign_up' do
    post 'Registers New User' do
      tags 'Registration'
      consumes 'application/json'

      parameter name: :blog, in: :body, schema: {
          type: :object,
          properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              username: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
          },
          required: ['first_name', 'last_name', 'username', 'password', 'password_confirmation']
      }

      response '200', 'User Registered' do
        schema type: :object,
               properties: {
                   id:         { type: :integer },
                   first_name: { type: :string },
                   last_name:  { type: :string },
                   username:   { type: :string }
               },
               required: [ 'id', 'first_name', 'last_name', 'username' ]
        run_test!
      end

      response '400', 'invalid request' do
        schema type: :object,
               properties: {
                   errors: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               field:     {type: :string},
                               code:      {type: :string},
                               error_msg: {type: :string}
                           }
                       }
                   }
               },
               required: ['field', 'code', 'error_msg' ]
        run_test!
      end
    end
  end
end