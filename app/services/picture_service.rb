class PictureService < ApplicationService
  def initialize(picture_params, current_user)
    super()
    @picture_params = picture_params
    @current_user = current_user
  end

  def json_view
    {picture: @picture.as_json(except: [:height, :width])}
  end

  def index_json_view
    {pictures: @result}
  end
  def upload
    picture_dimensions = MiniMagick::Image.open(@picture_params[:picture].path).dimensions
    @picture = Picture.create(category_id: @picture_params[:category_id],
                              user_id: @current_user.id,
                              image: @picture_params[:picture],
                              width: picture_dimensions[0],
                              height: picture_dimensions[1])
    @errors.concat @picture.formated_errors if @picture.errors.any?
  end

  def remove
    find_picture
    validate_access
    remove_picture
  end

  def index
    @result = Picture.select(:id, :uuid, :user_id, :category_id)
                     .where(user_filter)
                     .where(category_filter)
  end

  private

  def find_picture
    @picture = Picture.find_by(id: @picture_params[:id])
    fill_errors(:base, :not_found, "picture_not_found") unless @picture.present?
  end

  def validate_access
    return if errors.any?
    valid_owner = @picture.user_id == @current_user.id
    fill_errors(:base, :not_allowed, "not_allowed") unless valid_owner
  end

  def remove_picture
    return if errors.any?
    @picture.destroy
    @errors.concat @picture.formated_errors if @picture.errors.any?
  end

  def user_filter
    @picture_params[:user_id].present? ? "user_id = #{@picture_params[:user_id]}" : ""
  end

  def category_filter
    @picture_params[:category_id].present? ? "category_id = #{@picture_params[:category_id]}" : ""
  end
end