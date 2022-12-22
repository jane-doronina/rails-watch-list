class Movie < ApplicationRecord
  has_many :bookmarks

  validates :overview, presence: true, uniqueness: true

  def self.to_select
    Movie.order(rating: :desc).pluck(:title)
  end

  def self.to_json
    Movie.order(rating: :desc).map { |m| { id: m.id, title: m.title, rating: m.rating, overview: m.overview } }
  end
end
