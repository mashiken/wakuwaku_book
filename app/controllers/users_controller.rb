# frozen_string_literal: true

class UsersController < ApplicationController

  def index
  end

  def show
    @user = User.where(user_id: params[:id])
    @book_shelves = BookShelf.where(user_id: params[:id])
  end

  def edit
  end

  def update
  end

  def confirm
  end

  def hide
  end
end
