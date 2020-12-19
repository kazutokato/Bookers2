class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @books = Book.all
    @user = User.find(current_user.id)
    @users = User.all
  end

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @books = Book.all
    @user = @book.user
    @book_comment = BookComment.new
  end

  def create
    @book = Book.new(book_params)
    @books = Book.all
    @user = User.find(current_user.id)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You hava updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find_by(id:params[:id])
    if @book.destroy
      redirect_to books_path
    else
      render :edit
    end
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
