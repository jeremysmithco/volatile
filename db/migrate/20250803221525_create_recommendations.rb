class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations do |t|
      t.references :movie_night, null: false, foreign_key: true
      t.string :source
      t.text :list

      t.timestamps
    end
  end
end
