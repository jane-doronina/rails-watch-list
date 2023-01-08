require 'open-uri'

class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def index
    @lists = List.all
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if params[:photo].nil?
      list_photo = URI.open("https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80")
      @list.photo.attach(io: list_photo, filename: 'list.jpg', content_type: 'image/jpg')
    end

    if @list.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
  end

  private

  def list_params
    params.require(:list).permit(:name, :photo)
  end

  def set_list
    @list = List.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
