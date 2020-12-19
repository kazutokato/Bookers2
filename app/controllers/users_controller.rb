class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @user = User.find(current_user.id)
    @users = User.all
  end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page]).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def follower
    @users = User.all
    @user = User.find(params[:id])
  end

  def followed
    @users = User.all
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def correct_user
    @user = User.find(params[:id])
    if current_user != @user
      redirect_to user_path(current_user.id)
    end
  end
end
