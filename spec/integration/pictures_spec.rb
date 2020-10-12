require 'swagger_helper'
require 'rspec-rails'
RSpec.describe 'Registration Service' do

  path '/picture' do
    post 'Upload New Picture' do
      tags 'Picture'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :picture,     in: :formData, type: :file,    required: true
      parameter name: :category_id, in: :formData, type: :integer, required: true

      response '200', 'Picture Uploaded' do
        schema type: :object,
               properties: {
                   picture: {
                       type: :object,
                       properties: {
                           id:             {type: :integer},
                           uuid:           {type: :string},
                           category_id:    {type: :integer},
                           user_id:        {type: :integer},
                           attached_to_id: {type: :integer},
                           created_at:     {type: :string},
                           hsla_color: {
                               type: :array,
                               items: {
                                   type: :number,
                               }
                           }
                       }
                   }
               },
               required: %w[uuid category_id user_id attached_to_id created_at hsla_color]
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

  path '/picture/{id}' do
    get 'Get Picture' do
      tags 'Picture'
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

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   picture: {
                       type: :object,
                       properties: {
                           id:             {type: :integer},
                           uuid:           {type: :string},
                           category_id:    {type: :integer},
                           user_id:        {type: :integer},
                           attached_to_id: {type: :integer},
                           created_at:     {type: :string},
                           hsla_color: {
                               type: :array,
                               items: {
                                   type: :number,
                               }
                           },
                           similar_pictures: {
                               type: :array,
                               items: {
                                   properties: {
                                       id:             {type: :integer},
                                       uuid:           {type: :string},
                                       category_id:    {type: :integer},
                                       user_id:        {type: :integer},
                                       attached_to_id: {type: :integer},
                                       created_at:     {type: :string},
                                       hsla_color: {
                                           type: :array,
                                           items: {
                                               type: :number,
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               },
               required: %w[uuid category_id user_id attached_to_id created_at hsla_color]
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

  path '/picture/{uuid}/show' do
    get 'Get Picture' do
      tags 'Picture'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :uuid, in: :path, type: :string, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   picture: {
                       type: :file
                   }
               },
               required: [ 'file' ]
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

  path '/picture/{id}' do
    delete 'Delete Picture' do
      tags 'Picture'
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

      response '200', 'Picture Deleted' do
        schema type: :object,
               properties: {
                   picture: {
                       type: :object,
                       properties: {
                           uuid:           {type: :string},
                           category_id:    {type: :integer},
                           user_id:        {type: :integer},
                           attached_to_id: {type: :integer},
                           created_at:     {type: :string},
                           hsla_color: {
                               type: :array,
                               items: {
                                   type: :number,
                               }
                           }
                       }
                   }
               },
               required: %w[uuid category_id user_id attached_to_id created_at hsla_color]
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

  path '/pictures' do
    get 'Get All Picture' do
      tags 'Picture'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :user_id,     in: :query, type: :integer
      parameter name: :category_id, in: :query, type: :integer

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   pictures: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               uuid:           {type: :string},
                               category_id:    {type: :integer},
                               user_id:        {type: :integer},
                               attached_to_id: {type: :integer},
                               created_at:     {type: :string},
                               hsla_color: {
                                   type: :array,
                                   items: {
                                       type: :number,
                                   }
                               }
                           }
                       }
                   }
               },
               required: %w[uuid category_id user_id attached_to_id created_at hsla_color]
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

  path '/attach_similar' do
    post 'Attach Similar Picture' do
      tags 'Picture'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :picture,        in: :formData, type: :file,    required: true
      parameter name: :category_id,    in: :formData, type: :integer, required: true
      parameter name: :attached_to_id, in: :formData, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   picture: {
                       type: :object,
                       properties: {
                           uuid:           {type: :string},
                           category_id:    {type: :integer},
                           user_id:        {type: :integer},
                           attached_to_id: {type: :integer},
                           created_at:     {type: :string},
                           hsla_color: {
                               type: :array,
                               items: {
                                   type: :number,
                               }
                           },
                           similar_pictures: {
                               type: :array,
                               properties: {
                                   type: :object,
                                   properties: {
                                       uuid:           {type: :string},
                                       category_id:    {type: :integer},
                                       user_id:        {type: :integer},
                                       attached_to_id: {type: :integer},
                                       created_at:     {type: :string},
                                       hsla_color: {
                                           type: :array,
                                           items: {
                                               type: :number,
                                           }
                                       },
                                   }
                               }
                           }
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
end