class AddProfession < ActiveRecord::Migration
  def up
    add_column :users, :profession_id, :integer
    
    create_table "professions", :force => true do |t|
      t.string :name, :null => false      
    end
    
    ["Software Engineer", "Chef", "Acrobat", "Teacher"].each do |p|
      Profession.create!(:name => p)
    end
  end

  def down
    remove_column :users, :profession_id
  end
end
