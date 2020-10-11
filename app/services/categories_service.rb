class CategoriesService <ApplicationService
  def initialize(category_params, current_user)
    super()
    @category_params = category_params
    @current_user = current_user
  end

  def json_view
    {category: @category.as_json(except: [:user_id])}
  end

  def index_json_view
    {categories: @result}
  end

  def create
    @category = Category.create(name: @category_params[:name], user_id: @current_user.id)
    @errors.concat @category.formated_errors if @category.errors.any?
  end

  def index
    @result = Category.all
  end

  def update
    find_category
    validate_access
    update_category
  end

  def destroy
    find_category
    validate_access
    destroy_data
  end

  private

  def find_category
    @category = Category.find_by(id: @category_params[:category_id])
    fill_errors(:base, :not_found, "category_not_found") unless @category.present?
  end

  def validate_owner
    return if errors.any?
    valid_owner = @category.user_id == @current_user.id
    fill_errors(:nase, :not_allowed, "not_allowed") unless valid_owner
  end

  def destroy_data
    return if errors.any?
    @category.destroy
  end

  def update_category
    return if @errors.any?
    @category.update(name: @category_params[:name])
    @errors.concat @category.formated_errors if @category.errors.any?
  end
end