class CreateBankDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_details do |t|
      t.references :user, foreign_key: true
      t.string :account_number
      t.string :ifsc_number
      t.decimal :inflow_amount, precision: 12, scale: 2
      t.decimal :outflow_amount, precision: 12, scale: 2

      t.timestamps
    end
  end
end
