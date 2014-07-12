class ChangePhoneKindToEnum < ActiveRecord::Migration
  def up
    Phone.where(kind: 'Home').update_all(kind: 0)
    Phone.where(kind: 'Mobile').update_all(kind: 1)
    Phone.where(kind: 'Work').update_all(kind: 2)

    change_column :phones, :kind, :integer, default: 0
  end

  def down
    change_column :phones, :kind, :string
  end
end
