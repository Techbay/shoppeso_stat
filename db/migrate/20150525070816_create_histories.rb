class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :item_id
      t.string :user_id
      t.string :url
      t.string :action_name, default: "click"

      t.timestamps null: false
    end
  end
end
