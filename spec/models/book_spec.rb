require 'rails_helper'

describe Book, type: :model do 
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :pages }
    it { should validate_numericality_of(:pages).only_integer }
    it { should validate_numericality_of(:pages).is_greater_than_or_equal_to(1) }
    it { should validate_presence_of :year }
    it { should validate_numericality_of(:year).only_integer }
    it { should validate_numericality_of(:year).is_greater_than_or_equal_to(0) }
  end
  describe 'relationships' do
    it { should have_many(:book_authors) }
    it { should have_many(:authors).through(:book_authors) }
    it { should have_many(:reviews) }
    it { should have_many(:users).through(:reviews) }
  end

  describe 'class methods' do 
    it '.average_rating' do 
      @book_1 = Book.create(title: 'Book 1', pages: 10, year: 2015)
      @user_1 = User.create(name: 'User 1')
      @user_2 = User.create(name: 'User 2')
      @review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 2, book: @book_1, user: @user_1)
      @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 4, book: @book_1, user: @user_2)

      expect(@book_1.average_rating).to eq(3)
    end
    it '.rating_count' do 
      @book_1 = Book.create(title: 'Book 1', pages: 10, year: 2015)
      @user_1 = User.create(name: 'User 1')
      @user_2 = User.create(name: 'User 2')
      @review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 2, book: @book_1, user: @user_1)
      @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 4, book: @book_1, user: @user_2)

      expect(@book_1.rating_count).to eq(2)
    end
    describe '.get_sorted_books' do
      before(:each) do 
        @book_1 = Book.create(title: 'Book 1', pages: 10, year: 2015)
        @book_2 = Book.create(title: 'Book 2', pages: 20, year: 2016)
        @book_3 = Book.create(title: 'Book 3', pages: 30, year: 2017)
        @author_1 = Author.create(name: 'Author 1', books: [@book_1, @book_2])
        @author_2 = Author.create(name: 'Author 2', books: [@book_2])
        @author_3 = Author.create(name: 'Author 3', books: [@book_3])
        @user_1 = User.create(name: 'User 1')
        @user_2 = User.create(name: 'User 2')
        @review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 2, book: @book_1, user: @user_1)
        @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 3, book: @book_2, user: @user_1)
        @review_3 = Review.create(title: 'review title 3', description: 'review description 3', rating: 1, book: @book_3, user: @user_2)
      end
      it 'sorts by average rating in ascending order' do
        expect(Book.get_sorted_books({key: :avgrating, dir: :asc})).to eq([@book_3, @book_1, @book_2])
      end
      it 'sorts by average rating in descending order' do
        expect(Book.get_sorted_books({key: :avgrating, dir: :desc})).to eq([@book_2, @book_1, @book_3])
      end
      it 'sorts by page count in ascending order' do
        expect(Book.get_sorted_books({key: :pages, dir: :asc})).to eq([@book_1, @book_2, @book_3])
      end
      it 'sorts by page count in descending order' do
        expect(Book.get_sorted_books({key: :pages, dir: :desc})).to eq([@book_3, @book_2, @book_1])
      end
      it 'sorts by review count in ascending order' do
        @review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 2, book: @book_1, user: @user_1)
        @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 3, book: @book_2, user: @user_1)
        @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 3, book: @book_2, user: @user_1)
        expect(Book.get_sorted_books({key: :revcount, dir: :asc})).to eq([@book_3, @book_1, @book_2])
      end
      it 'sorts by review count in descending order' do
        @review_1 = Review.create(title: 'review title 1', description: 'review description 1', rating: 2, book: @book_1, user: @user_1)
        @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 3, book: @book_2, user: @user_1)
        @review_2 = Review.create(title: 'review title 2', description: 'review description 2', rating: 3, book: @book_2, user: @user_1)
        expect(Book.get_sorted_books({key: :revcount, dir: :desc})).to eq([@book_2, @book_1, @book_3])
      end
    end
    describe 'stats methods' do
      before(:each) do 
        @book_1 = Book.create(title: 'Book 1', pages: 10, year: 2015)
        @book_2 = Book.create(title: 'Book 2', pages: 20, year: 2016)
        @book_3 = Book.create(title: 'Book 3', pages: 30, year: 2017)
        @book_4 = Book.create(title: 'Book 4', pages: 40, year: 2018)
        @book_5 = Book.create(title: 'Book 5', pages: 50, year: 2019)
        @book_6 = Book.create(title: 'Book 6', pages: 50, year: 2019)
        @user_1 = User.create(name: 'User 1')
        user_2 = User.create(name: 'User 2')
        user_3 = User.create(name: 'User 3')
  
        review_1 = Review.create(title: 'review 1', description: 'description 1', rating: 1, book: @book_1, user: @user_1)
        review_2 = Review.create(title: 'review 2', description: 'description 2', rating: 2, book: @book_2, user: user_2)
        review_3 = Review.create(title: 'review 3', description: 'description 3', rating: 3, book: @book_3, user: user_3)
        review_4 = Review.create(title: 'review 4', description: 'description 4', rating: 4, book: @book_4, user: user_2)
        review_5 = Review.create(title: 'review 4', description: 'description 5', rating: 5, book: @book_5, user: user_3)
        review_6 = Review.create(title: 'review 5', description: 'description 6', rating: 5, book: @book_5, user: user_3)
      end
      describe '.get_best_rated_books' do
        it 'lists in alphabetical book title if there is a tie' do
          review_4 = Review.create(title: 'review 4', description: 'description 4', rating: 5, book: @book_4, user: @user_1)
          expect(Book.get_best_rated_books(3)).to eq([@book_4, @book_5, @book_5])
        end
        it 'lists in order if there is no tie' do
          expect(Book.get_best_rated_books(3)).to eq([@book_5, @book_5, @book_4])
        end
      end
      it '.get_worst_rated_books' do
        expect(Book.get_worst_rated_books(3)).to eq([@book_1, @book_2, @book_3])
      end
    end
  end
end