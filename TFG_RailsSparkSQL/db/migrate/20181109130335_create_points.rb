class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.string :ident
      t.string :name
      t.string :element
      t.string :x
      t.string :y

      t.timestamps
    end
  end
end
