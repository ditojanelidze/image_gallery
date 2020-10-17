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
               required: %w[access_token refresh_token]

        before do
           User.create(first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       username: 'TestUser',
                       password: 'Password123')
        end
        let(:params){{username: 'TestUser', password: 'Password123'}}
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
               required: %w[errors]
        let(:params){{username: 'InvalidUser', password: 'InvalidPassword'}}
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
               required: %w[access_token refresh_token]

        before do
          User.create(first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      username: 'TestUser',
                      password: 'Password123')
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @refresh = service.json_view[:refresh_token]
        end
        let(:params){{refresh_token: @refresh}}
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
               required: %w[errors]
        let(:params){{refresh_token: SecureRandom.uuid}}
        run_test!
      end
    end
  end
end