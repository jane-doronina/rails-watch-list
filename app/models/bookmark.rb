class Bookmark < ApplicationRecord
  belongs_to :movie
  belongs_to :list

  validates :movie_id, presence: true
  # validates :movie_id, uniqueness: {scope: :list_id, message: "is already in the list"}
  # validates :comment, length: { minimum: 6 }
end
