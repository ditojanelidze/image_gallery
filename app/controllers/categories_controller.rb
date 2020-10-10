class CategoriesController < ApplicationController
  def create
    service = CategoriesService.new(create_params, current_user)
    service.create
    render service.result
  end

  private

  def create_params
    params.permit(:name)
  end
end