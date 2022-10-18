class UsersController < ApplicationController
  def index
    @users = User.where(user_id: params[:id])
    @sum = Expense.where(user_id: params[:id]).pluck(:amount).sum
  end

  # GET /users/1 or /users/1.json
  def show
  end

  def report
    @expenses = Expense.where(user_id: params[:id])
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email)
  end
end
