require 'rails_helper'

describe User, type: :model do 
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
  describe 'relationships' do
    it { should have_many(:reviews) }
    it { should have_many(:books).through(:reviews) }
  end
  describe 'class functions' do 
    it '.best_reviewers' do
      book_1 = Book.create(title: "Book 1", pages: 10, year: 2001)
      book_2 = Book.create(title: "Book 2", pages: 20, year: 2002)
      book_3 = Book.create(title: "Book 3", pages: 30, year: 2003)
      user_1 = User.create(name: 'User 1')
      user_2 = User.create(name: 'User 2')
      user_3 = User.create(name: 'User 3')
      user_4 = User.create(name: 'User 4')
      Review.create(book: book_1, user: user_4, title: 'title 1', description: 'description 1', rating: 4)
      Review.create(book: book_2, user: user_4, title: 'title 2', description: 'description 2', rating: 4)
      Review.create(book: book_3, user: user_4, title: 'title 3', description: 'description 3', rating: 4)
      Review.create(book: book_1, user: user_3, title: 'title 4', description: 'description 4', rating: 4)
      Review.create(book: book_2, user: user_3, title: 'title 5', description: 'description 5', rating: 4)
      Review.create(book: book_1, user: user_2, title: 'title 6', description: 'description 6', rating: 4)

      expect(User.best_reviewers(3)).to eq([user_4, user_3, user_2])
    end
  end
end