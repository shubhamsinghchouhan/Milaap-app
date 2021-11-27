class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :pan_card, limit: 10
      t.string :aadhar_number, limit: 12

      t.timestamps
    end
  end
end
