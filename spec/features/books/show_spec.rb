require 'rails_helper'

describe 'book show page, as a visitor' do 
  it 'should show all basic data about the book' do
    author_1 = Author.create(name: 'Author 1')
    book = Book.create(title: 'Book 1', pages: 500, year: 2015, authors: [author_1])
    user = User.create(name: 'User 1')
    review = Review.create(user: user, book: book, title: 'review title', description: 'review description', rating: 4)
    visit book_path(book)

    expect(page).to have_content(book.title)
    expect(page).to have_content("#{book.pages} pages")
    expect(page).to have_content("Published in #{book.year}")
    within '#authors' do 
      book.authors.each do |author|
        expect(page).to have_content(author.name)
      end
    end

    within '#reviews' do 
      within "#review-#{review.id}" do
        expect(page).to have_content(review.user.name)
        expect(page).to have_content(review.title)
        expect(page).to have_content(review.description)
        expect(page).to have_content("#{review.rating} stars")
        expect(page).to have_content("written #{review.created_at}")
      end
    end
  end
end