class CreateHeadlines < ActiveRecord::Migration
  def change
    create_table :headlines do |t|

      t.timestamps
    end
  end
end
