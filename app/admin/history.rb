ActiveAdmin.register History do
  menu :priority => 4
  actions :all, except: [:new, :create, :update, :edit]
  config.sort_order = "id_desc"

  index :download_links => false do
    selectable_column
    column :id
    column :item_id
    column :user_id
    column :created_at
    actions
  end

  filter :item_id
  filter :user_id
  filter :created_at

  show do
    attributes_table do
      row :id
      row :item_id
      row :user_id
      row :url
      row :action_name
      row :created_at
    end
  end
end
