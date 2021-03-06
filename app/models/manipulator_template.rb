class ManipulatorTemplate < ActiveRecord::Base
  belongs_to :user
  
  has_many :variable_properties
  validate :validate_coffeescript
  before_save :generate_javascript
  after_save :add_missing_vars

  scope :sorted_by_priority, :order => "priority ASC"

  def short_safe_json
    {
      :id => "template:#{self.id}",
      :manipulator_template_id => self.id,
      :name => self.name,
      :image_url => self.image_url
    }
  end

  def validate_coffeescript
    begin
      CoffeeScript.compile(self.formula)
      CoffeeScript.compile(self.can_formula) if !self.can_formula.blank?
      CoffeeScript.compile(self.do_formula) if !self.do_formula.blank?
    rescue ExecJS::RuntimeError => e
      errors.add(:formula, "Invalid Coffeescript: #{e.to_s}")
    end
  end
  
  def generate_javascript
    self.javascript = CoffeeScript.compile(self.formula, {:bare => true})
    self.can_javascript = CoffeeScript.compile(self.can_formula, {:bare => true}) if !self.can_formula.blank?
    self.do_javascript = CoffeeScript.compile(self.do_formula, {:bare => true}) if !self.do_formula.blank?
  end
  
  def variables
    vars = []
    (self.formula + (self.can_formula || '') + (self.do_formula || '')).scan(/params\['([\S_]+?)'\]/) do |match|
      vars << {:name => $1, :type => :param} if !vars.detect { |a| a[:name] == $1 }
    end
    vars
  end
  
  def add_missing_vars
    variables.each do |v|
      if !variable_properties.detect { |vp| vp.name == v[:name] }
        variable_properties.create!(:name => v[:name], :var_type => 'string')
      end
    end
  end

  def default_param_value(key)
    vp = variable_properties.detect { |vp| vp.name == key }
    if vp
      vp.default
    end
  end
  
  def params
    variables.find_all { |v| v[:type] == :param }.collect do |v|
      props = variable_properties.detect { |vp| vp.name == v[:name] }
      [v[:name], props || {}]
    end
  end

  def params_hash(manipulator)
    variables.find_all { |v| v[:type] == :param }.collect do |var|
      props = variable_properties.detect { |vp| vp.name == var[:name] }
      {
        :name => props.name,
        :display => props.name.gsub('_',' ').split.map(&:capitalize).join(' '),
        :type => props.var_type,
        :options => (props.options || '').split(','),
        :description => {:text => props.description },
        :depends_on_variable => props.depends_on ? props.depends_on.split(':')[0] : nil,
        :depends_on_value => props.depends_on ? props.depends_on.split(':')[1] : nil,

        :value => manipulator.param_value(props.name)
      }
    end
  end
  
end