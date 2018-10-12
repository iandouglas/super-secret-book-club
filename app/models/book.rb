class Book < ApplicationRecord
  validates_presence_of :title
  validates :pages, presence: true, numericality: {
    only_integer: true, 
    greater_than_or_equal_to: 1
  }
  validates :year, presence: true, numericality: {
    only_integer: true, 
    greater_than_or_equal_to: 0
  }

  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :reviews
  has_many :users, through: :reviews

  def average_rating
    reviews.average(:rating).to_f
  end

  def rating_count
    reviews.count 
  end

  def self.get_sorted_books(params)
    if params[:key]
      dir = :asc
      dir = :desc if params[:dir].to_sym == :desc

      if params[:key].to_sym == :pages
        Book.order(pages: dir)
      else
        if params[:key].to_sym == :avgrating
          agg = 'coalesce(avg(reviews.rating),0)'
        elsif params[:key].to_sym == :revcount
          agg = 'count(reviews)'
        else
          return Book.all
        end
      
        Book.select("books.*, #{agg} as agg_data")
          .joins('left join reviews on reviews.book_id=books.id')
          .group(:book_id, :id)
          .order("agg_data #{dir}")
      end
    else
      Book.all
    end
  end

  def self.get_best_rated_books(lmt)
    Book.select('books.*, reviews.rating').joins(:reviews).order("reviews.rating desc, books.title asc").limit(lmt)
  end

  def self.get_worst_rated_books(lmt)
    Book.select('books.*, reviews.rating').joins(:reviews).order("reviews.rating asc, books.title asc").limit(lmt)
  end

end