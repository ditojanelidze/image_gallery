require 'swagger_helper'
require 'rspec-rails'
RSpec.describe 'Category Services' do

  path '/category' do
    post 'Create New Category' do
      tags 'Category'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name: { type: :string }
          }, required: ['name']
      }

      response '200', 'Category Created' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id:         { type: :integer },
                           name:       { type: :string },
                           created_at: { type: :string }
                       }
                   }
               },
               required: [ 'id', 'name', 'created_at']
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

  path '/categories' do
    get 'Get All Categories' do
      tags 'Category'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   categories: {
                       type: :array,
                       items: {
                           properties: {
                               id:         { type: :integer },
                               name:       { type: :string },
                               user_id:    { type: :string },
                               created_at: { type: :string }
                           }
                       }
                   }
               }, required: %w[id name user_id created_at]
        run_test!
      end
    end
  end

  path '/category/{id}' do
    put 'Update Category' do
      tags 'Category'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name: { type: :string }
          }, required: %w[id name]
      }

      response '200', 'Category Updated' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id:         { type: :integer },
                           first_name: { type: :string },
                           last_name:  { type: :string },
                           username:   { type: :string }
                       }
                   }
               },
               required: %w[id first_name last_name username]
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
               required: %w[field code error_msg]
        run_test!
      end
    end
  end

  path '/category/{id}' do
    delete 'Delete Category' do
      tags 'Category'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Category Deleted' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id:         { type: :integer },
                           name: { type: :string },
                           created_at:  { type: :string }
                       }
                   }
               },
               required: %w[id name created_at]
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
               required: %w[field code error_msg]
        run_test!
      end
    end
  end
end