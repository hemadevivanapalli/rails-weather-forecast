# frozen_string_literal: true

# ForecastsController handles the form submission for weather forecasts based on user-inputted address.
class ForecastsController < ApplicationController
  # Renders the form for a new forecast request
  def new; end

  # Processes the address, fetches forecast and renders results
  def create
    @address = params[:address]

    if @address.blank?
      @error_message = "Please enter an address."
      return render :new
    end

    result = ForecastFetcherService.call(@address)

    if result.failure?
      @error_message = result.error
      return render :new
    end

    @forecast_data = result.forecast_data
    @cached = result.cached
    render :new
  end
end
