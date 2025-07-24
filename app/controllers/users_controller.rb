class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :asc, id: :asc).page(params[:page])
  end

  def show
  end
end
