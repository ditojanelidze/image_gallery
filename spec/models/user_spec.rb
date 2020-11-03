RSpec.describe User do
  before do
    @password = "Qwerty1$"
  end

  context "User Model Validation" do
    it "should create user" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: @password)
      expect(user).to be_valid
    end

    it "should produce first_name null false error" do
      user = User.create(first_name: nil,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: @password)
      expect(user.errors.details[:first_name].first[:error]).to eq :blank
    end

    it "should produce first_name too long error" do
      user = User.create(first_name: "a"*51,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: @password)
      expect(user.errors.details[:first_name].first[:error]).to eq :too_long
    end

    it "should produce last_name null false error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: nil,
                         username: Faker::Internet.username,
                         password: @password)
      expect(user.errors.details[:last_name].first[:error]).to eq :blank
    end

    it "should produce last_name too long error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: "a"*51,
                         username: Faker::Internet.username,
                         password: @password)
      expect(user.errors.details[:last_name].first[:error]).to eq :too_long
    end

    it "should produce username null false error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: nil,
                         password: @password)
      expect(user.errors.details[:username].first[:error]).to eq :blank
    end

    it "should produce username too long error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: "a"*51,
                         password: @password)
      expect(user.errors.details[:username].first[:error]).to eq :too_long
    end

    it "should produce username uniqueness error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: @password)

      duplicated_user =  User.create(first_name: Faker::Name.first_name,
                                     last_name: Faker::Name.last_name,
                                     username: user.username,
                                     password: @password)
      expect(duplicated_user.errors.details[:username].first[:error]).to eq :taken
    end

    it "should produce password null false error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: nil)
      expect(user.errors.details[:password].first[:error]).to eq :blank
    end

    it "should produce password too long error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: "a"*201)
      expect(user.errors.details[:password].first[:error]).to eq :too_long
    end
  end
end
