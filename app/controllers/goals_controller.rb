class GoalsController < BaseManipulatorController

  before_filter :get_user

  def index
    if params[:plan_id]
      plan = Plan.find(params[:plan_id])
    else
      plan = @current_user.plans.first
    end
    respond_to do |format|
      format.html do
        render :partial => 'list', :object => plan.goals, :locals => {:unused_list => plan.unused_goals, :editable => params[:editable] == 'true'}
      end
      format.json do
        list = plan.goals.sort_by { |g| g.id }.collect { |g| g.short_safe_json.merge({:used => true}) }
        if params[:unused] != 'false'
          list += plan.unused_goals.sort_by { |g| g.id }.collect { |g| g.short_safe_json.merge({:used => false}) }
        end
        render :json => list
      end
    end
  end

  def show
    if params[:id] =~ /template:(\d+)/
      @template = ManipulatorTemplate.find($1)
      if params[:plan_id]
        plan = Plan.find(params[:plan_id])
      else
        plan = @current_user.plans.first
      end
      @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)
    else
      @manipulator = Manipulator.find(params[:id])
      @template = @manipulator.manipulator_template
    end

    render :json => @manipulator.safe_json
  end

  def new
    @template = ManipulatorTemplate.find(params[:manipulator_template_id])
    plan = Plan.find(params[:plan_id])
    @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)

    render :layout => false
  end

  def create
    @m = Manipulator.new(:params => {}.to_json)
    when_params(@m)
    @m.update_attributes(params.require(:manipulator).permit!)
    @m.params = params[:variables].to_json
    @m.plan_id = @current_user.plans.first.id

    if @m.save
      render :json => {:id => @m.id}
    else
      render :action => "new"
    end
  end

  def update
    m = Manipulator.find(params[:id])
    when_params(m)

    super
  end

  def when_params(manipulator)
    if params[:when_type] == 'asap'
      params[:manipulator][:start] = nil
      params[:manipulator][:end] = nil
    elsif params[:when_type] == 'age'
      pu = manipulator.plan.plan_users.detect { |pu| pu.id == params[:when_person].to_i }
      params[:manipulator][:start_plan_user_id] = pu.id
      params[:manipulator][:start] = pu.born + (params[:when_age].to_i*366)
      params[:manipulator][:end] = params[:manipulator][:start]
    elsif params[:when_type] == 'year'
      params[:manipulator][:start] = Date.parse("1/1/#{params[:when_year]}")
      params[:manipulator][:end] = params[:manipulator][:start]
    else
      raise StandardError, "Unknown when type #{params[:when_type]}"
    end
    params[:manipulator][:start_type] = params[:when_type]
  end

  def show_results
    @manipulator = Manipulator.find(params[:id])
    @template = @manipulator.manipulator_template

    render :layout => false
  end

  def destroy
    @manipulator = Manipulator.find(params[:id])
    @manipulator.destroy

    render :text => 'ok'
  end

end
