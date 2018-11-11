class CreateEpoches < ActiveRecord::Migration[5.1]
  def change
    create_table :epoches do |t|
      t.string :name
      t.string :vmed
      t.string :x
      t.string :y
      t.string :executionId

      t.timestamps
    end
  end
end
