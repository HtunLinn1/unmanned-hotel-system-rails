class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :room_type
      t.integer :room_no
      t.integer :price
      t.integer :limit_person
      t.timestamps
    end
  end
end
