class CreateActiveOperatorOperations < ActiveRecord::Migration[8.0]
  def change
    create_table :active_operator_operations do |t|
      t.references :record, polymorphic: true, null: false, index: true
      t.string :name, null: false
      t.integer :version, null: false
      t.json :response, null: false, default: "{}"
      t.datetime :received_at
      t.datetime :processed_at
      t.datetime :failed_at

      t.timestamps
    end
  end
end
