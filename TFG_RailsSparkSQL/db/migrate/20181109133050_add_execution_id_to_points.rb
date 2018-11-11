class AddExecutionIdToPoints < ActiveRecord::Migration[5.1]
  def change
    add_column :points, :executionId, :string
  end
end
