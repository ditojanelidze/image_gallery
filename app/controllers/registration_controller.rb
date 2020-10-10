class RegistrationController < ApplicationController
  def sign_up
    service = RegistrationService.new(sign_up_params)
    service.sign_up
    render service.result
  end

  private

  def sign_up_params
    params.permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end
end