class CreatePizzas < ActiveRecord::Migration[7.1]
  def change
    create_table :pizzas do |t|
      t.string :name, default: '', null: false
      t.string :description, default: '', null: false
      t.decimal :price, scale: 2, precision: 5, default: 0.0, null: false
      t.integer :size, default: 0, null: false
      t.references :chef, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :pizzas, :name, unique: true
  end
end
