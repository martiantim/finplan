class TaxRateSchedule < ActiveRecord::Base

  has_many :tax_brackets, :order => "range_top ASC"

  def safe_json
    {
        :name => self.name,
        :brackets => self.tax_brackets.collect(&:safe_json)
    }
  end
end