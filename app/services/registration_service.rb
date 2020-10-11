class RegistrationService < ApplicationService

  @@password_regex = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/

  def initialize(sign_up_params)
    super()
    @sign_up_params = sign_up_params
    @errors = []
  end

  def json_view
    { user: @user.as_json(except: [:password, :created_at]) }
  end

  def sign_up
    validate_password
    register_user
  end

  private

  def validate_password
    validate_password_match
    validate_password_format
  end

  def register_user
    return if errors.any?
    @user = User.create(@sign_up_params.except(:password_confirmation))
    @errors.concat(@user.formated_errors) if @user.errors.any?
  end

  def validate_password_match
    return if errors.any?
    passwords_match = @sign_up_params[:password] == @sign_up_params[:password_confirmation]
    fill_errors(:password, :not_match,"password_not_matched") unless passwords_match
  end

  def validate_password_format
    return if errors.any?
    valid_format = @@password_regex.match? @sign_up_params[:password]
    fill_errors(:password, :invalid,"invalid_password_format") unless valid_format
  end
end