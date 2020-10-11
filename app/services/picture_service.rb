class PictureService < ApplicationService
  @@max_records_count = 20
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

  def attach_similar
    find_similar
    validate_aspect_ratio
    validate_extension
    create_picture
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
                     .page(@picture_params[:page])
                     .per([@picture_params[:page_limit], @@max_records_count].min )
  end

  private

  def find_picture
    @picture = Picture.find_by(id: @picture_params[:id])
    fill_errors(:base, :not_found, "picture_not_found") unless @picture.present?
  end

  def find_similar
    @similar_picture = Picture.find_by(id: @picture_params[:attached_to_id])
    fill_errors(:base, :not_found, "picture_not_found") unless @similar_picture.present?
  end

  def create_picture
    return if errors.any?
    picture_dimensions = MiniMagick::Image.open(@picture_params[:picture].path).dimensions
    @picture = Picture.create(category_id: @picture_params[:category_id],
                              user_id: @current_user.id,
                              image: @picture_params[:picture],
                              width: picture_dimensions[0],
                              height: picture_dimensions[1],
                              attached_to_id: @similar_picture.id)
    @errors.concat @picture.formated_errors if @picture.errors.any?
  end

  def validate_aspect_ratio
    return if errors.any?
    picture_dimensions = MiniMagick::Image.open(@picture_params[:picture].path).dimensions
    ratio_of_similar = @similar_picture.height.to_d/@similar_picture.width
    ratio_of_uploaded = picture_dimensions[1].to_d/picture_dimensions[0]
    similar = ((ratio_of_similar-ratio_of_uploaded).abs/ratio_of_similar)*100 <= 10
    fill_errors(:base, :invalid, "not_similar") unless similar
  end

  def validate_extension
    return if errors.any?
    similar = @picture_params[:picture].content_type == @similar_picture.image.content_type
    fill_errors(:base, :invalid, "not_similar") unless similar
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