class CreateBankDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_details do |t|
      t.string :account_number
      t.string :ifsc_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
