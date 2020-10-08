class RegistrationController
  def sign_up

  end

  private

  def sing_up_params
    params.permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end
end