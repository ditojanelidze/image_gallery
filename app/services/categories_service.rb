class CategoriesService <ApplicationService
  def initialize(category_params, current_user)
    super()
    @category_params = category_params
    @current_user = current_user
  end

  def json_view
    {category: @category.as_json(except: [:user_id])}
  end

  def create
    @category = Category.create(name: @category_params[:name], user_id: @current_user.id)
    @errors.concat @category.formated_errors if @category.errors.any?
  end
end