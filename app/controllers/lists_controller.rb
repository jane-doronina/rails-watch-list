require 'open-uri'

class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def index
    @lists = List.all
    @list = List.new
  end

  def autocomplete
    list = Movie.order(:title)
               .where("title ilike :q", q: "%#{params[:q]}%")

    render json: list.map { |m| { id: m.id, title: m.title, rating: m.rating, overview: m.overview } }
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if params[:list][:photo].nil?
      list_photo = URI.open("https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80")
      @list.photo.attach(io: list_photo, filename: 'list.jpg', content_type: 'image/jpg')
    end

    respond_to do |format|
      if @list.save
        # format.turbo_stream { render turbo_stream: turbo_stream.append("lists_list", partial: "lists/list", locals: { list: @list }) }
        format.turbo_stream { redirect_to list_path(@list) }
        format.html { redirect_to list_path(@list), notice: "List successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "lists/form_modal", locals: {list: @list }) }
        format.html { render :new, status: :unprocessable_entity, notice: "Please check the form for more details." }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @list = List.find(params[:id])
    @new_list = List.new
    @bookmark = Bookmark.new
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to lists_path, status: :see_other
  end

  private

  def list_params
    params.require(:list).permit(:name, :photo)
  end

  def set_list
    @list = List.find(params[:id])
  end

end
