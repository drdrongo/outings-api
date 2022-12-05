class Api::V1::OutingsController < ApplicationController
  def show
    outing = Outing.find(params[:id])
    if outing
      render json: { data: outing }, status: 200
    else
      render json: { errors: outing.errors.full_messages }, status: 422
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

    @outings = Outing
               .where(where)
               .joins(:user, :spot)
               .select('outings.*, spots.location, users.f_name AS user_f_name, users.image AS user_image')

    if @outings
      render json: { data: @outings }, status: 200
    else
      render json: { errors: @outings.errors.full_messages }, status: 422
    end
  end

  def create
    response = Outing.create!(outing_params)
    render json: response
  end

  def delete; end

  def update
    outing = Outing.find(params[:id])
    if outing
      outing.update(params)
      # outing.update(is_favorite: !outing.is_favorite)
      render json: { data: outing }, status: 200
    else
      render json: { errors: outing.errors.full_messages }, status: 422
    end
  end

  private

  def outing_params
    params.require(:outing).permit(
      :couple_id, :spot_id, :rating, :date_time, :images, :is_complete,
      :is_favorite, :title, :description, :price, :mood, :genre
    )
  end
end
