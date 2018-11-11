class AddExecutionIdToSpeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :speeds, :executionId, :string
  end
end
