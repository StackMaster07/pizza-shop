class CreatePizzaToppings < ActiveRecord::Migration[7.1]
  def change
    create_table :pizza_toppings do |t|
      t.references :pizza, foreign_key: true
      t.references :topping, foreign_key: true
      t.integer :quantity, default: 1, null: false

      t.timestamps
    end
  end
end
