class CategoriesController < ApplicationController
  def create
    service = CategoriesService.new(create_params, current_user)
    service.create
    render service.result
  end

  def index
    service = CategoriesService.new({}, current_user)
    service.index
    render service.result "index"
  end

  def update
    service = CategoriesService.new(update_params, current_user)
    service.update
    render service.result
  end

  def destroy
    service = CategoriesService.new(destroy_params, current_user)
    service.destroy
    render service.result
  end

  private

  def create_params
    params.permit(:name)
  end

  def update_params
    params.permit(:id, :name)
  end

  def destroy_params
    params.permit(:id)
  end
end