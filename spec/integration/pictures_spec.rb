require 'swagger_helper'
require 'rspec-rails'
RSpec.describe 'Registration Service' do

  path '/picture' do
    post 'Upload New Picture' do
      tags 'Picture'
      consumes 'application/form-data'
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
               required: ['picture']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          @category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          @uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                 filename: File.basename(file),
                                                                 type: "image/png")
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:category_id){@category.id}
        let(:picture) {@uploaded_file}
        # run_test!    Rswag doesn't support formData params to be tested
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
                                   type: :string,
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
                                               type: :string,
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               },
               required: ['picture']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                 filename: File.basename(file),
                                                                 type: "image/png")
          parent_picture = Picture.create( user_id: user.id,
                                     category_id:category.id,
                                     image: uploaded_file,
                                     uuid: SecureRandom.hex,
                                     height: 10,
                                     width: 10)
          @picture = Picture.create( user_id: user.id,
                                     category_id:category.id,
                                     image: uploaded_file,
                                     uuid: SecureRandom.hex,
                                     attached_to_id: parent_picture.id,
                                     height: 10,
                                     width: 10,
                                     hsla_color: [1,2,3])
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:id){@picture.id}
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
        let(:id){rand(1000)}
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
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                 filename: File.basename(file),
                                                                 type: "image/png")
          @picture = Picture.create( user_id: user.id,
                                     category_id:category.id,
                                     image: uploaded_file,
                                     uuid: SecureRandom.hex,
                                     height: 10,
                                     width: 10,
                                     hsla_color: [1,2,3])
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:uuid){@picture.uuid}
        # run_test! Rswag doesn't support formData params to be tested
      end

      response '404', 'Not found' do
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
        let(:uuid){SecureRandom.uuid}
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
                                   type: :string,
                               }
                           }
                       }
                   }
               },
               required: ['picture']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                 filename: File.basename(file),
                                                                 type: "image/png")
          parent_picture = Picture.create(user_id: user.id,
                                          category_id:category.id,
                                          image: uploaded_file,
                                          uuid: SecureRandom.hex,
                                          height: 10,
                                          width: 10)
          @picture = Picture.create( user_id: user.id,
                                     category_id:category.id,
                                     image: uploaded_file,
                                     uuid: SecureRandom.hex,
                                     attached_to_id: parent_picture.id,
                                     height: 10,
                                     width: 10,
                                     hsla_color: [1,2,3])
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:id){@picture.id}
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
        let(:id){rand(1000)}
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
               required: ['pictures']
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
        let(:user_id){nil}
        let(:category_id){nil}
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
               required: ['picture']
        before do
          user = User.create(first_name: Faker::Name.first_name,
                             last_name: Faker::Name.last_name,
                             username: 'TestUser',
                             password: 'Password123')
          category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                 filename: File.basename(file),
                                                                 type: "image/png")
          @parent_picture = Picture.create(user_id: user.id,
                                          category_id:category.id,
                                          image: uploaded_file,
                                          uuid: SecureRandom.hex,
                                          height: 10,
                                          width: 10)
          @picture = Picture.create( user_id: user.id,
                                     category_id:category.id,
                                     image: uploaded_file,
                                     uuid: SecureRandom.hex,
                                     attached_to_id: @parent_picture.id,
                                     height: 10,
                                     width: 10,
                                     hsla_color: [1,2,3])
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:pictures){@picture}
        let(:attached_to_id){@parent_picture.id}
        # run_test! Rswag doesn't support formData params to be tested
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
          @category = Category.create(name: Faker::Movies.name, user_id: user.id)
          file = File.open("#{Rails.root}/spec/integration/files/Golang-Cover-1.png")
          @uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: file,
                                                                  filename: File.basename(file),
                                                                  type: "image/png")

          @parent_picture = Picture.create(user_id: user.id,
                                           category_id: @category.id,
                                           image: @uploaded_file,
                                           uuid: SecureRandom.hex,
                                           height: 10,
                                           width: 10)
          service = AuthService.new({username: 'TestUser', password: 'Password123'})
          service.auth
          @jwt = service.json_view[:access_token]
        end
        let(:Authorization){"Bearer #{@jwt}"}
        let(:category_id){@category.id}
        let(:picture){@uploaded_file}
        let(:attached_to_id){@parent_picture.id}
        run_test!
      end
    end
  end
end