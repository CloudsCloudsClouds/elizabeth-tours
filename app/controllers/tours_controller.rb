class ToursController < ApplicationController
  before_action :set_tour, only: %i[ show ]

  def index
    @tours = Tour.all.with_attached_images
  end

  def show
  end

  private
    def set_tour
      @tour = Tour.find(params.expect(:id))
    end
end
