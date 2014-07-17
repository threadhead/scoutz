class CreateMeritBadges < ActiveRecord::Migration
  def change
    create_table :merit_badges do |t|
      t.string :name
      t.string :year_created
      t.boolean :eagle_required, default: false
      t.boolean :discontinued, default: false
      t.string :bsa_advancement_id
      t.string :patch_image_url
      t.string :mb_org_url
      t.string :mb_org_worksheet_pdf_url
      t.string :mb_org_worksheet_doc_url

      t.timestamps
    end
    add_index :merit_badges, :name
  end
end
