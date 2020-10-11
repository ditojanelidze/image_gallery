class PictureService < ApplicationService
  def initialize(picture_params, current_user)
    super()
    @picture_params = picture_params
    @current_user = current_user
  end

  def json_view
    {picture: @picture.as_json(except: [:height, :width])}
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

  private

  def find_picture
    @picture = Picture.find_by(id: @picture_params[:picture_id])
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
end