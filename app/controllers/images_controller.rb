class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
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
    if @image.save
      ContactMailer.contact_mail(@image).deliver
      redirect_to images_path, notice: '投稿し、投稿確認メールを送信しました'
    else
      render 'new'
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
