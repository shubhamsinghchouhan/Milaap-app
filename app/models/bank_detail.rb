# frozen_string_literal: true

# This model helps to store and fetch bank details
class BankDetail < ApplicationRecord
  belongs_to :user
  has_many :loan_applications, dependent: :destroy

  validates :account_number, :ifsc_number, presence: true
  validates :account_number, uniqueness: true
end
