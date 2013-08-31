class AccountInvestmentType < ActiveRecord::Migration
  def up
    add_column :accounts, :investment_type, :string
  end

  def down
    remove_column :accounts, :investment_type
  end
end
