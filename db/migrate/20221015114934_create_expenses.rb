class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :category, null: false, foreign_key: true
      t.integer :amount
      t.text :description

      t.timestamps
    end
  end
end
