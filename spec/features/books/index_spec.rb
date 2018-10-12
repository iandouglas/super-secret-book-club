require 'rails_helper'

describe 'book index page, as a visitor' do
  before(:each) do
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
  end
  describe 'show all books' do
    it 'should show all book details' do 
      visit books_path

      [@book_1, @book_2, @book_3].each do |book|
        within("#book-#{book.id}") do 
          expect(page).to have_content(book.title)
          expect(page).to have_content("Pages: #{book.pages}")
          expect(page).to have_content("Year: #{book.year}")
        end
      end
    end
    it 'should show average book rating and reviw count' do 
      visit books_path

      [@book_1, @book_2, @book_3].each do |book|
        within("#book-#{book.id}") do 
          expect(page).to have_content("Average Rating: #{book.average_rating}")
          expect(page).to have_content("Rating Count: #{book.reviews.count}")
        end
      end
    end
    describe 'has links to sort data' do 
      it 'should not sort anything with bad parameters' do 
        visit books_path(key: :lkjasdlkj, dir: :asc)
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_1.title)
          expect(all('.book-title')[1]).to have_content(@book_2.title)
          expect(all('.book-title')[2]).to have_content(@book_3.title)
        end
      end
      it 'should sort by average rating in ascending order' do 
        visit books_path
        click_link 'Sort By Average Rating, Low to High'

        expect(page).to have_current_path(books_path(key: :avgrating, dir: :asc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_3.title)
          expect(all('.book-title')[1]).to have_content(@book_1.title)
          expect(all('.book-title')[2]).to have_content(@book_2.title)
        end
      end
      it 'should sort by average rating in descending order' do
        visit books_path
        click_link 'Sort By Average Rating, High to Low'

        expect(page).to have_current_path(books_path(key: :avgrating, dir: :desc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_2.title)
          expect(all('.book-title')[1]).to have_content(@book_1.title)
          expect(all('.book-title')[2]).to have_content(@book_3.title)
        end
      end
      it 'should sort by page count in ascending order' do 
        visit books_path
        click_link 'Sort By Page Count, Low to High'

        expect(page).to have_current_path(books_path(key: :pages, dir: :asc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_1.title)
          expect(all('.book-title')[1]).to have_content(@book_2.title)
          expect(all('.book-title')[2]).to have_content(@book_3.title)
        end
      end
      it 'should sort by page count in descending order' do 
        visit books_path
        click_link 'Sort By Page Count, High to Low'

        expect(page).to have_current_path(books_path(key: :pages, dir: :desc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_3.title)
          expect(all('.book-title')[1]).to have_content(@book_2.title)
          expect(all('.book-title')[2]).to have_content(@book_1.title)
        end
      end
      it 'should sort by review count in ascending order' do 
        visit books_path
        click_link 'Sort By Review Count, Low to High'

        expect(page).to have_current_path(books_path(key: :revcount, dir: :asc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_3.title)
          expect(all('.book-title')[1]).to have_content(@book_1.title)
          expect(all('.book-title')[2]).to have_content(@book_2.title)
        end
      end
      it 'should sort by review count in descending order' do 
        visit books_path
        click_link 'Sort By Review Count, High to Low'

        expect(page).to have_current_path(books_path(key: :revcount, dir: :desc))
        within '#all-books' do
          expect(all('.book-title')[0]).to have_content(@book_2.title)
          expect(all('.book-title')[1]).to have_content(@book_1.title)
          expect(all('.book-title')[2]).to have_content(@book_3.title)
        end
      end
    end
    describe 'shows book statistics' do
      before(:each) do 
        @book_4 = @author_1.books.create(title: 'Book 4', pages: 40, year: 2017)
        @book_5 = @author_1.books.create(title: 'Book 5', pages: 50, year: 2018)
        @user_3 = User.create(name: 'User 3')
        @user_4 = User.create(name: 'User 4')
        Review.create(book: @book_4, user: @user_1, rating: 4, title: 'review 4', description: 'description 4')
        Review.create(book: @book_5, user: @user_4, rating: 5, title: 'review 5', description: 'description 5')
        Review.create(book: @book_3, user: @user_4, rating: 5, title: 'review 5', description: 'description 5')
      end
      it 'shows three of the highest-rated books' do 
        visit books_path

        within('#stats') do
          within('#best-books') do
            expect(all('.best-book-title')[0]).to have_content(@book_3.title)
            expect(all('.best-book-title')[1]).to have_content(@book_5.title)
            expect(all('.best-book-title')[2]).to have_content(@book_4.title)
          end
        end
      end
      it 'shows three of the worst-rated books' do 
        visit books_path

        within('#stats') do
          within('#worst-books') do
            expect(all('.worst-book-title')[0]).to have_content(@book_1.title)
            expect(all('.worst-book-title')[1]).to have_content(@book_2.title)
            expect(all('.worst-book-title')[2]).to have_content(@book_2.title)
          end
        end
      end
      it 'shows three users who have written the most reviews' do 
        visit books_path

        within('#stats') do
          within('#reviewing-users') do
            expect(all('.user-name')[0]).to have_content(@user_1.name)
            expect(all('.user-name')[1]).to have_content(@user_4.name)
            expect(all('.user-name')[2]).to have_content(@user_2.name)
          end
        end
      end
    end
  end

end