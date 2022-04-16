class CreateRuns < ActiveRecord::Migration[6.1]
  def change
    create_table :runs do |t|
      t.datetime :date
      t.float :distance
      t.string :time
      t.float :average_speed

      t.timestamps
    end
  end
end
