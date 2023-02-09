class BookmarksController < ApplicationController
  before_action :set_list, only: [ :new, :create]

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

    respond_to do |format|
      if @bookmark.save
        format.turbo_stream { render turbo_stream: turbo_stream.append("movies-list", partial: "lists/movie_card", locals: { list: @list, bookmark: @bookmark }) }
        format.html { redirect_to list_path(@list), notice: "Movie successfully added." }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "lists/form_modal", locals: {list: @list, bookmark: @bookmark }) }
        format.html { render :new, status: :unprocessable_entity, notice: "Please check the form for more details." }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
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
