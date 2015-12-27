class ExpensesController < BaseManipulatorController

  before_filter :get_user
  before_filter :login_required

  def new
    @template = ManipulatorTemplate.find(params[:manipulator_template_id])
    plan = Plan.find(params[:plan_id])
    @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)
    
    render :layout => false
  end

  def index
    if params[:plan_id]
      @plan = Plan.find(params[:plan_id])
    else
      @plan = @current_user.plans.first
    end

    respond_to do |format|
      format.html do
        render :partial => 'list', :object => @plan.expenses, :locals => {:unused_list => @plan.unused_expenses}
      end
      format.json do
        list = @plan.expenses.sort_by { |g| g.id }.collect { |g| g.short_safe_json.merge({:used => true}) }
        list += @plan.unused_expenses.sort_by { |g| g.id }.collect { |g| g.short_safe_json.merge({:used => false}) }

        render :json => list
      end
    end
  end

  def show
    if params[:plan_id]
      @plan = Plan.find(params[:plan_id])
    else
      @plan = @current_user.plans.first
    end

    if params[:id] =~ /template:(\d+)/
      @template = ManipulatorTemplate.find($1)
      @manipulator = Manipulator.new(:manipulator_template => @template, :plan => @plan, :name => @template.name)
    else
      @manipulator = Manipulator.find(params[:id])
      @template = @manipulator.manipulator_template
    end

    h = @manipulator.safe_json
    h[:removable] = @manipulator.manipulator_template.name != 'Living Expenses'

    render :json => h
  end
  
  def create
    @m = Manipulator.new(params.require(:manipulator).permit!)
    @m.params = params[:variables].to_json

    if @m.save
      render :json => {:id => @m.id}
    else
      render :action => "new"
    end
  end

  def destroy
    @manipulator = Manipulator.find(params[:id])        
    @manipulator.destroy    
    
    render :text => 'ok'
  end
  
end
