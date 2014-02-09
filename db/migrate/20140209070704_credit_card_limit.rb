class CreditCardLimit < ActiveRecord::Migration
  def change
    add_column :accounts, :limit, :integer, :default => 0
  end
end
