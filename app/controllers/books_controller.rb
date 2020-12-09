class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @books = Book.all
    @user = User.find(current_user.id)
  
    @users = User.all
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.all
    @user = @book.user
  end

  def create
    @book = Book.new(book_params)
    @books = Book.all
    @user = User.find(current_user.id)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to books_path
    else
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    if current_user != @user
      redirect_to books_path
    end
  end
end
