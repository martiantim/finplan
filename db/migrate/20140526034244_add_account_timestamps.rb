class AddAccountTimestamps < ActiveRecord::Migration
  def change
    add_column :accounts, :created_at, :datetime
    add_column :accounts, :updated_at, :datetime
  end
end
