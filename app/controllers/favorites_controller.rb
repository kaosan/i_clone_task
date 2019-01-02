class FavoritesController < ApplicationController

  def create
    favorite = current_user.favorites.create(image_id: params[:image_id])
    redirect_to images_url, notice: "#{favorite.image.user.name}さんの投稿をお気に入り登録しました"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to images_url, notice: "#{favorite.image.user.name}さんの投稿をお気に入り解除しました"
  end
end
