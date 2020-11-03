require 'rails_helper'

RSpec.describe AuthService do
  before do
    @password = "Qwerty1$"
    @user = User.create(first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name,
                        username: Faker::Internet.username,
                        password: @password)
  end

  context "Auth Service Validation" do
    it "should generate tokens forvalid user" do
      auth_params = {username: @user.username, password: @password}
      service = AuthService.new(auth_params)
      service.auth
      expect(service.errors.count).to eq 0
      expect(service.json_view[:access_token]).not_to be_nil
      expect(service.json_view[:refresh_token]).not_to be_nil
    end

    it "should produce unauthorized error" do
      auth_params = {username: "InvalidUsername", password: @password}
      service = AuthService.new(auth_params)
      service.auth
      expect(service.errors.count).to eq 1
      expect(service.errors[0][:code]).to eq :unauthorized
      expect(service.errors[0][:field]).to eq :base
    end
  end
end