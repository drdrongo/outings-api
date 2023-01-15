class Api::V1::OutingsController < ApplicationController
  before_action :set_outing, only: %i[show update destroy]

  def show
    if @outing
      render json: { data: @outing }, status: 200
    else
      render json: { errors: @outing.errors.full_messages }, status: 422
    end
  end

  def index
    where = '1=1'
    params&.each do |key, val| # Is this safe? SQL wise?
      if %w[genre mood price is_complete is_favorite].include? key # %i for array of symbols
        where += " AND #{key} = '#{val}'"
      elsif %w[title].include? key
        where += " AND LOWER(#{key}) LIKE '%#{val.downcase}%'"
      end
    end


    is_last_page = Outing.page(params[:page] || 1).last_page?

    @outings = Outing.joins('LEFT JOIN users ON users.id = outings.user_id LEFT JOIN spots ON spots.id = outings.spot_id')
                     .where(where)
                     .page(params[:page] || 1)
                     .per(7)
                     .select('outings.*, spots.location, users.f_name AS user_f_name, users.image AS user_image')

    if @outings
      render json: { data: @outings, is_last_page: is_last_page }, status: 200
    else
      render json: { errors: @outings.errors.full_messages }, status: 422
    end
  end

  def create

    response = Outing.create!(outing_params)
    render json: response
  end

  def destroy
    @outing.destroy
    if @outing.destroyed?
      render json: { success: true }, status: 200
    else
      render json: { errors: @outing.errors.full_messages }, status: 422
    end
  end

  def update
    if @outing.update(outing_params)
      render json: { data: @outing }, status: 200
    else
      render json: { errors: @outing.errors.full_messages }, status: 422
    end
  end

  private

  def outing_params
    params.require(:outing).permit(
      :id,
      :couple_id, :spot_id, :rating, :date_time, :images, :is_complete,
      :is_favorite, :title, :description, :price, :mood, :genre,
      :user_id,
      :page
    )
  end

  def set_outing
    @outing = Outing.find(params[:id])
  end

end
