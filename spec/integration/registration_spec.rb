require 'swagger_helper'
require 'rspec-rails'
RSpec.describe 'Registration Service' do

  path '/sign_up' do
    post 'Registers New User' do
      tags 'Registration'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              username: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
          }
      }

      response '200', 'User Registered' do
        schema type: :object,
               properties: {
                   user: {
                       type: :object,
                       properties: {
                           id:         { type: :integer },
                           first_name: { type: :string },
                           last_name:  { type: :string },
                           username:   { type: :string }
                       }
                   }
               },
               required: %w[user]
        let(:params) do
          {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              username: Faker::Internet.username,
              password: 'Password123',
              password_confirmation: 'Password123'
          }
        end
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
        let(:params) do
          {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              username: Faker::Internet.username,
              password: 'Password123',
              password_confirmation: 'PasswordDontMatch'
          }
        end
        run_test!
      end
    end
  end
end