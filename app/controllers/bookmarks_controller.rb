class BookmarksController < ApplicationController
  before_action :set_list, only: [:new, :create]

  def new
    @bookmark = Bookmark.new
  end

  def autocomplete
    list = Movie.order(:title)
               .where("title ilike :q", q: "%#{params[:q]}%")

    render json: list.map { |m| { id: m.id, title: m.title, rating: m.rating, overview: m.overview } }
  end

  def create
    @movie = Movie.find_by(title: params[:title])
    @bookmark = Bookmark.new(movie: @movie, comment: bookmark_params[:comment])
    @bookmark.list = @list
    if @bookmark.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), status: :see_other
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
