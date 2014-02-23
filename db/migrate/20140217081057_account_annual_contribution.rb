class AccountAnnualContribution < ActiveRecord::Migration
  def change
    add_column :accounts, :annual_contribution, :integer, :default => 0, :null => false
  end
end
