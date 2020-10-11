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

  private

  def upload_params
    params.permit(:picture, :category_id)
  end

  def remove_params
    params.permit(:picture_id)
  end
end