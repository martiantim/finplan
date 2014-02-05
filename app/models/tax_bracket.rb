class TaxBracket < ActiveRecord::Base
  belongs_to :tax_rate_schedule

  def safe_json
    {
        :range_top => self.range_top,
        :rate => self.rate
    }
  end
end