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
               required: [ 'category']
        before do
          User.create(first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      username: 'TestUser',
                      password: 'Password123')
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params) {{name: Faker::Movies.name}}
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
               required: ['errors']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              username: 'TestUser',
                              password: 'Password123')
          Category.create(name: 'CategoryName', user_id: user.id)
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params) {{name: 'CategoryName'}}
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
                           type: :object,
                           properties: {
                               id:         { type: :integer },
                               name:       { type: :string },
                               user_id:    { type: :integer },
                               created_at: { type: :string }
                           }
                       }
                   }
               }, required: ['categories']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          Category.create(name: Faker::Movies.name, user_id: user.id)
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
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
               required: ['category']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          @category = Category.create(name: 'CategoryName', user_id: user.id)
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params){{name: "NewCategoryName"}}
        let(:id){@category.id}
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
               required: ['errors']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params){{name: "NewCategoryName"}}
        let(:id){rand(1000)}
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
               required: ['category']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          @category = Category.create(name: 'CategoryName', user_id: user.id)
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params){{name: "NewCategoryName"}}
        let(:id){@category.id}
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
               required: ['errors']
        before do
          User.create(first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      username: 'TestUser',
                      password: 'Password123')
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:params){{name: "NewCategoryName"}}
        let(:id){rand(1000)}
        run_test!
      end
    end
  end
end