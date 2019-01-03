class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destro]
before_action :logged_in?, only: [:new, :edit, :show, :destroy]

  def index
    @images = Image.all
  end

  def new
    if params[:back]
      @image = Image.new(image_params)
    else
      @image = Image.new
    end
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: '投稿しました!' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @favorite = current_user.favorites.find_by(image_id: @image.id)
  end

  def edit
    unless @image.user_id == current_user.id
      redirect_to images_path, notice: "権限がありません"
    end
  end

  def update
    if @image.update(image_params)
      redirect_to images_path, notice: 'ブログを編集しました'
    else
      render 'edit'
    end
  end

  def destroy
    @image.destroy
    redirect_to images_path, notice: 'ブログを削除しました'
  end

  def confirm
    @user = User.find(session[:user_id])
    @image = Image.new(image_params)
    @image.user_id = current_user.id
    render :new if @image.invalid?
  end

  private

  def image_params
     params.require(:image).permit(:image, :content, :image_cache)
  end

  def set_image
  @image = Image.find(params[:id])
end

def logged_in?
  unless current_user.present?
    flash[:notice] = 'ログインしてください'
    redirect_to new_session_path
  end
end

end
