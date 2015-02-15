class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = BeermappingApi.place(params[:id])
  end

end