class CreateMovieNights < ActiveRecord::Migration[8.0]
  def change
    create_table :movie_nights do |t|
      t.date :watched_on
      t.datetime :completed_at

      t.timestamps
    end
  end
end
