class ArchangelsController < ApplicationController
  before_action :set_archangel, only: [:show, :update, :destroy]

  def index
    @archangels = Archangel.all
    render json: @archangels
  end

  def show
    render json: @archangel
  end

  def create
    @archangel = Archangel.new(archangel_params)
    if @archangel.save
      render json: @archangel, status: :created
    else
      render json: @archangel.errors, status: :unprocessable_entity
    end
  end

  def update
    if @archangel.update(archangel_params)
      render json: @archangel
    else
      render json: @archangel.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @archangel.destroy
    head :no_content
  end

  private

  def set_archangel
    @archangel = Archangel.find(params[:id])
  end

  def archangel_params
    params.require(:archangel).permit(:name, :description, :color)
  end
end
