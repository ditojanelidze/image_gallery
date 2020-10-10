class ApplicationService

  attr_reader :errors

  def initialize
    @errors = []
  end

  def error_json_view
    {errors: @errors}
  end

  def json_view
    {status: :ok}
  end

  def result(action = "")
    if @errors.any?
      {json: error_json_view, status: 400}
    else
      {json: action.present? ? send("#{action}_json_view") : json_view}
    end
  end

  private

  def fill_errors(field, code, error_msg)
    @errors << {field: field, code: code, error_msg: error_msg}
  end

  def custom_error_msg(msg_type)
    I18n.t("custom_errors.#{msg_type}")
  end
end