class PicturesController < ApplicationController
  def upload
    service = PictureService.new(upload_params, current_user)
    service.upload
    render service.result
  end

  def remove
    service = PictureService.new(remove_params, current_user)
    service.remove
    render service.result
  end

  def index
    service = PictureService.new(index_params, current_user)
    service.index
    render service.result
  end

  private

  def upload_params
    params.permit(:picture, :category_id)
  end

  def remove_params
    params.permit(:id)
  end

  def index_params
    params.permit(:category_id, :user_id)
  end
end