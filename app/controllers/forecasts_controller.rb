class ForecastsController < ApplicationController
  def new; end
  def create
    @address = params[:address]
    zip = GeocoderService.extract_zip(@address)

    unless zip
      flash.now[:alert] = "Couldn’t find a ZIP code for that input"
      return render :new
    end

    begin
      @forecast, @cached = ForecastFetcherService.fetch(zip)
      render :show
    rescue ForecastFetcherService::Error => e
      Rails.logger.error(e.message)
      flash.now[:alert] = "Weather service unavailable (try again later)"
      render :new
    end
  end
end
