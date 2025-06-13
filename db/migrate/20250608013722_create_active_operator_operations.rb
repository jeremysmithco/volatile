class CreateActiveOperatorOperations < ActiveRecord::Migration[8.0]
  def change
    create_table :active_operator_operations do |t|
      t.string :type, null: false
      t.references :record, polymorphic: true, null: false, index: true
      t.json :response, null: false, default: "{}"
      t.datetime :received_at
      t.datetime :processed_at
      t.datetime :errored_at

      t.timestamps
    end
  end
end
