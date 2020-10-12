require 'swagger_helper'
require 'rspec-rails'
RSpec.describe 'Auth Services' do

  path '/auth' do
    post 'Authenticate And Receive Tokens' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              username: { type: :string },
              password: { type: :string }
          }
      }

      response '200', 'User Registered' do
        schema type: :object,
               properties: {
                   access_token:  { type: :string },
                   refresh_token: { type: :string }
               },
               required: [ 'access_token', 'refresh_token']
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

  path '/refresh' do
    post 'Refresh And Receive New Tokens' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              refresh_token: { type: :string }
          }
      }, required: ['refresh_token']

      response '200', 'Authenticated' do
        schema type: :object,
               properties: {
                   access_token:  { type: :string },
                   refresh_token: { type: :string }
               },
               required: [ 'access_token', 'refresh_token']
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