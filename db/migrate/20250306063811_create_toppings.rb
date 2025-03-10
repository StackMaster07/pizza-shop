class CreateToppings < ActiveRecord::Migration[7.1]
  def change
    create_table :toppings do |t|
      t.string :name, default: '', null: false
      t.integer :quantity, default: 0, null: false
      t.decimal :price_per_piece, default: 0, null: false      
      t.timestamps
    end

    add_index :toppings, :name, unique: true
  end
end
