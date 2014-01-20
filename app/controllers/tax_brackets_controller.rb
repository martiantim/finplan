class TaxBracketsController < ApplicationController

  def new
    @bracket = TaxBracket.new(:tax_rate_schedule_id => params[:schedule_id])
  end

  def create
    @bracket = TaxBracket.new(params.require(:tax_bracket).permit!)

    if @bracket.save
      redirect_to("/tax_rate_schedules/#{@bracket.tax_rate_schedule_id}")
    else
      render :action => "new"
    end
  end

  def destroy
    @bracket = TaxBracket.find(params[:id])
    @schedule = @bracket.tax_rate_schedule
    @bracket.destroy

    redirect_to("/tax_rate_schedules/#{@schedule.id}")
  end
end