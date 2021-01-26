class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :img_url
      t.string :title
      t.string :year
      t.string :stars
      t.string :rating
      t.text :price
      t.text :description

      t.timestamps
    end
  end
end
