class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[edit update destroy]
  def new
    @bookmark = Bookmark.new
    @list = List.find(params[:list_id])
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @list = List.find(params[:list_id])
    @bookmark.list = @list # sets the list id

    if @bookmark.save
      redirect_to list_path(@list)
    else
      # if it fails to save
      # show what went wrong on the form
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @list = List.find(params[:list_id]) # list_idを取得
    @bookmark = @list.bookmarks.find(params[:id]) # list内のbookmarkを取得
  end

  def update
    @list = List.find(params[:list_id])
    @bookmark = @list.bookmarks.find(params[:id])

    if @bookmark.update(bookmark_params)
      redirect_to list_path(@list), notice: 'Bookmark was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), notice: 'Bookmark was successfully destroyed.'
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
