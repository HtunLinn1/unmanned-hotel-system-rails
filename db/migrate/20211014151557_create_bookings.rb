class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.string :credit_no
      t.integer :person_count
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :packing
      t.boolean :check_out
      t.boolean :paied
      t.boolean :cancle
      t.string :key
      t.timestamps
    end
  end
end
