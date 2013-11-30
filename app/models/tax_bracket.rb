class TaxBracket < ActiveRecord::Base
  belongs_to :tax_rate_schedule
end