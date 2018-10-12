class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :reviews
  has_many :books, through: :reviews
  has_many :authors, through: :books

  def self.best_reviewers(lmt)
    User.select('users.*, count(reviews.id) as review_count')
      .joins(:reviews).group('users.id')
      .order('review_count desc')
      .limit(lmt)
  end
end