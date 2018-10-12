class BooksController < ApplicationController
  def index
    @books = Book.get_sorted_books(params)
    @best_books = Book.get_best_rated_books(3)
    @worst_books = Book.get_worst_rated_books(3)
    @reviewing_users = User.best_reviewers(3)
  end

  def show 
    @book = Book.find(params[:id])
  end
end