class ChangePhoneKindToEnum < ActiveRecord::Migration
  # will need to do in-place conversion: add new kind_i column, copy integer values to kind_i,
  #   remove kind column, rename kind_i -> kind

  def up
    add_column :phones, :kind_i, :integer, default: 0
    Phone.where(kind: 'Home').update_all(kind_i: 0)
    Phone.where(kind: 'Mobile').update_all(kind_i: 1)
    Phone.where(kind: 'Work').update_all(kind_i: 2)

    remove_column :phones, :kind
    rename_column :phones, :kind_i, :kind
  end

  def down
    change_column :phones, :kind, :string
  end
end
