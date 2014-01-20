class TaxRateSchedule < ActiveRecord::Base

  has_many :tax_brackets, :order => "range_top ASC"

end