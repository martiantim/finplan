class AccountInterestRate < ActiveRecord::Migration
  def up
    add_column :accounts, :interest_rate, :decimal
  end

  def down
  end
end
