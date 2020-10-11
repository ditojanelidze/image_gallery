class PicturesController < ApplicationController
  def upload
    service = PictureService.new(upload_params, current_user)
    service.upload
    render service.result
  end

  def show
    service = PictureService.new(show_params, current_user)
    service.show
    render service.result
  end

  def attach_similar
    service = PictureService.new(attach_similar_params, current_user)
    service.attach_similar
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
    render service.result "index"
  end

  private

  def upload_params
    params.permit(:picture, :category_id)
  end

  def show_params
    params.permit(:id)
  end

  def attach_similar_params
    params.permit(:picture, :category_id, :attached_to_id)
  end

  def remove_params
    params.permit(:id)
  end

  def index_params
    params.permit(:category_id, :user_id)
  end
end