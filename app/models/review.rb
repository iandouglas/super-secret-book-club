class Review < ApplicationRecord
  validates_presence_of :title, :description
  validates :rating, presence: true, numericality: {
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 5
  }

  belongs_to :user
  belongs_to :book
  has_many :authors, through: :book
end