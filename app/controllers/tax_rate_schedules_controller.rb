class TaxRateSchedulesController < ApplicationController
  def index
    @schedules = TaxRateSchedule.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @schedules.collect(&:safe_json).to_json }
    end
  end

  def new
    @schedule = TaxRateSchedule.new()
  end

  def create
    @schedule = TaxRateSchedule.new(params[:tax_rate_schedule])

    if @schedule.save
      redirect_to('/tax_rate_schedules')
    else
      render :action => "new"
    end
  end

  def show
    @schedule = TaxRateSchedule.find(params[:id])
  end
end