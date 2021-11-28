class CreateLoanApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_applications do |t|
      t.decimal :inflow_amount, precision: 12, scale: 2, default: 0.0
      t.decimal :outflow_amount, precision: 12, scale: 2, default: 0.0
      t.integer :creditibility_score, default: 0
      t.boolean :is_approved, default: false
      t.references :bank_detail, foreign_key: true

      t.timestamps
    end
  end
end
