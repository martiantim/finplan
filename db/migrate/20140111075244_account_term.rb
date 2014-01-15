class AccountTerm < ActiveRecord::Migration
  def up
    add_column :accounts, :term, :integer
  end

  def down
  end
end
