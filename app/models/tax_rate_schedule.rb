class TaxRateSchedule < ActiveRecord::Base
  attr_accessible :name

  has_many :tax_brackets, :order => "range_top ASC"

end