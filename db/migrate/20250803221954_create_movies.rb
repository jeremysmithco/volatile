class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.references :movie_night, null: false, foreign_key: true
      t.string :title
      t.string :mpaa_rating
      t.integer :runtime_minutes
      t.text :description
      t.integer :release_year

      t.timestamps
    end
  end
end
