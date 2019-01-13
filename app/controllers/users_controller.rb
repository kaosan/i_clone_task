class UsersController < ApplicationController
  before_action :logged_in?, only: [:show, :edit, :new, :destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @favorites_images = @user.favorites
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :icon, :icon_cache)
  end
end
