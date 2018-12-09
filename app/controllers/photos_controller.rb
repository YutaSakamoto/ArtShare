class PhotosController < ApplicationController

  def create
    @craft = Craft.find(params[:craft_id])

    if params[:images]
      params[:images].each do |img|
        @craft.photos.create(image: img)
      end

      @photos = @craft.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @craft = @photo.craft

    @photo.destroy
    @photos = Photo.where(craft_id: @craft.id)

    respond_to :js
  end
end
