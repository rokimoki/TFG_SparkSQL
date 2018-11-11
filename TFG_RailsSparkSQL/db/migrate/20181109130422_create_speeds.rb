class CreateSpeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :speeds do |t|
      t.string :ident
      t.string :date
      t.string :element
      t.string :vmed

      t.timestamps
    end
  end
end
