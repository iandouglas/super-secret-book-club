# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


@book_1 = Book.create(title: 'Book 1', pages: 10, year: 2015)
@book_2 = Book.create(title: 'Book 2', pages: 20, year: 2016)
@book_3 = Book.create(title: 'Book 3', pages: 30, year: 2017)
@author_1 = Author.create(name: 'Author 1', books: [@book_1, @book_2])
@author_2 = Author.create(name: 'Author 2', books: [@book_2])
@author_3 = Author.create(name: 'Author 3', books: [@book_3])
@user_1 = User.create(name: 'User 1')
@user_2 = User.create(name: 'User 2')
@review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 1, book: @book_1, user: @user_1)
@review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 2, book: @book_2, user: @user_1)
@review_3 = Review.create(title: 'review title 3', description: 'review description 3', rating: 3, book: @book_2, user: @user_2)
