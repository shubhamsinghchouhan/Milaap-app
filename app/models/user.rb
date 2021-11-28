# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bank_details, dependent: :destroy
  has_many :loan_applications, through: :bank_details

  validates :email, :pan_card, :aadhar_number, presence: true, uniqueness: true
  validates_associated :bank_details

  accepts_nested_attributes_for :bank_details
end
