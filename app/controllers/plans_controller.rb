#TODO: [+] next to add account
#TODO: house value in net worth
#TODO: show interest rates of loans
#TODO: dont count college costs as an every year expense for retirement

#TODO: logo outline
#TODO: warning/advice system
#TODO: suggestions when bankruptcy or goal not achieved
#TODO: better handling of accounts in javascript
#TODO: help text for all account types
#TODO: allow specifying IRA savings in accounts page
#TODO: allow adding 2nd/3rd car
#TODO: April worked into their golden years -> links for improvements "_save more_ in IRA accounts"
#TODO: do all logging thru simcontext
#TODO: keep track of basis and only pay taxes on gains
#TODO: remaining state income tax schedules
#TODO: still in school
#TODO: childcare
#TODO: goal: more school [say how much higher/lower will make salary]
#TODO: goal: vacation home
#TODO: taxes on social security
#TODO: goal pay off credit cards
#TODO: if all goals achieved say "try a scenario"
#TODO: graduation hat for when finish college
#TODO: move to another state when retire

#2.0
#TODO: landing page: http://blog.kissmetrics.com/landing-page-design-infographic/
#TODO: 30 year mortgage in market performance
#TODO: bonuses (tied to stock market?)
#TODO: contractor
#TODO: able to control when take social security
#TODO: show green/yellow/red in need/have table
#TODO: cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
#TODO: goal: investment property
#
#
# Target:
#   -living in USA
#   -age range 18-65
#   -single or married
#   -in school or working
#   -income range 30k-300k approx
#
# Usage scenarios:
#   -can I retire?
#   -can I buy a house and retire
#   -how will going back to school help me financially
#   -can I take time off to spend with kids
#   -what if SS goes away?

class PlansController < ApplicationController

  before_filter :get_user
  before_filter :login_required

  def show
    @plan = Plan.find(params[:id])
  end

  def show2
    @plan = Plan.find(params[:id])
  end
  
  def reload
    @plan = Plan.find(params[:id])
    render :json => {
      :id => @plan.id,
      :state => @plan.state,
      :manipulators => @plan.priority_sorted_manipulators.collect(&:safe_json),
      :accounts => @plan.accounts.collect(&:safe_json),
      :family_members => @plan.plan_users.collect(&:safe_json),
      :todos => calc_todos()
    }
  end

  def update
    plan = Plan.find(params[:id])
    plan.update_attributes(params.require(:plan).permit!)

    render :json => {:id => plan.id, :controller => 'plans'}
  end

  private


  def calc_todos
    list = []
    list << todo_retirement
    list << todo_family
    list << todo_job
    list << todo_accounts
    list << todo_expenses

    list.compact
  end

  def todo_retirement
    m = @plan.manipulator_by_name('Retire')
    return if !m || m.created_at != m.updated_at

    {
      :id => 'Retirement',
      :description => "Setup your retirement goals",
      :link => "#/goals/#{m.id}",
      :image_url => "http://www.clipartguide.com/_named_clipart_images/0511-1001-2706-2216_Retired_Man_Resting_in_a_Hammock_with_a_Book_clipart_image.jpg"
    }
  end

  def todo_family
    return if @plan.plan_users.length > 1
    pu = @plan.plan_users.first
    return if !pu || pu.created_at != pu.updated_at

    {
      :id => 'Family',
      :description => "Tell me a little bit about your family",
      :link => "#/family",
      :image_url => "http://thumbs.gograph.com/gg55085791.jpg"
    }
  end

  def todo_job
    m = @plan.manipulator_by_name('Salary')
    return if !m || m.created_at != m.updated_at
    pu = @plan.plan_users.first
    return if pu.profession_id

    {
        :id => 'Job',
        :description => "What's your profession",
        :link => "#/family/#{pu.id}",
        :image_url => "http://bestclipartblog.com/clipart-pics/job-clip-art-1.gif"
    }
  end

  def todo_accounts
    @plan.accounts.each do |acct|
      return if acct.created_at != acct.updated_at
    end

    pu = @plan.plan_users.first
    {
        :id => 'Accounts',
        :description => "What are your current account balances?",
        :link => "#/accounts",
        :image_url => "http://hibamagazine.com/hibakidz/wp-content/uploads/2013/09/TN_money-_bank_213.jpg"
    }
  end

  def todo_expenses
    m = @plan.manipulator_by_name('Living Expenses')
    return if !m || m.created_at != m.updated_at

    {
      :id => 'Expenses',
      :description => "Setup your basic living expenses",
      :link => "#/expenses/#{m.id}",
      :image_url => "http://www.officeclipart.com/office_clipart_images/boss_shocked_by_list_of_expenses_0521-1012-0921-2200_SMU.jpg"
    }
  end
  
end
