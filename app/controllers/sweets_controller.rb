class SweetsController < ApplicationController
  before_action :set_sweet, only: %i[show update destroy]
  def index
    @sweets = nil
    if params[:shop_id].present?
      shop = Shop.find(params[:shop_id])
      @sweets = shop.sweets.all
    elsif params[:category_id].present?
      category = Category.find(params[:category_id])
      @sweets = category.sweets.all
    else
      @sweets = Sweet.all
    end
    render json: @sweets
  end

  def show
    render json: @sweet
  end

  def create
    @sweet = Sweet.new(sweet_params)
    shop = Shop.find(params[:shop_id])
    @sweet.shop = shop

    if @sweet.save
      render json: @sweet, status: :created, location: @sweet
    else
      render json: @sweet.errors, status: :unprocessable_entity
    end
  end

  def update
    if @sweet.update(sweet_params)
      render json: @sweet
    else
      render json: @sweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @sweet.destroy
  end

  private

  def set_sweet
    @sweet = Sweet.find(params[:id])
  end

  def sweet_params
    params.require(:sweet).permit(:name, :description, :price, :imagePath)
  end
end
