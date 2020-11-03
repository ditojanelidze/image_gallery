require 'rails_helper'

RSpec.describe RegistrationService do
  before do
    @password = "Qwerty1$"
  end

  context "Registration Service Vlidation" do
    it "should register new user succesfully" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 1
      expect(service.errors).to be_empty
      expect(service.json_view[:user]).not_to be_nil
    end

    it "should produce first_name must be filled error" do
      registration_params = {
          first_name: nil,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :blank
      expect(service.errors[0][:field]).to eq :first_name
    end

    it "should produce first_name too long error" do
      registration_params = {
          first_name: "a"*51,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :too_long
      expect(service.errors[0][:field]).to eq :first_name
    end

    it "should produce last_name must be filled error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: nil,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :blank
      expect(service.errors[0][:field]).to eq :last_name
    end

    it "should produce last_name too long error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: "a"*51,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :too_long
      expect(service.errors[0][:field]).to eq :last_name
    end

    it "should produce username must be filled error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: nil,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :blank
      expect(service.errors[0][:field]).to eq :username
    end

    it "should produce username too long error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: "a"*51,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :too_long
      expect(service.errors[0][:field]).to eq :username
    end

    it "should produce password invalid error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: nil,
          password_confirmation: nil
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :invalid
      expect(service.errors[0][:field]).to eq :password
    end

    it "should produce password invalid error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: "a"*201,
          password_confirmation: "a"*201
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :invalid
      expect(service.errors[0][:field]).to eq :password
    end

    it "should produce password dont match error" do
      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: Faker::Internet.username,
          password: @password,
          password_confirmation: "InvalidPass"
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 0
      expect(service.errors[0][:code].to_sym).to eq :not_match
      expect(service.errors[0][:field]).to eq :password
    end

    it "should produce username taken error" do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         username: Faker::Internet.username,
                         password: @password)

      registration_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          username: user.username,
          password: @password,
          password_confirmation: @password
      }

      service = RegistrationService.new(registration_params)
      service.sign_up
      expect(User.count).to eq 1
      expect(service.errors[0][:code].to_sym).to eq :taken
      expect(service.errors[0][:field]).to eq :username
    end
  end
end
