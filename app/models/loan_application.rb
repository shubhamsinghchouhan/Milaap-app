# frozen_string_literal: true

# This model helps to store and fetch loan application
class LoanApplication < ApplicationRecord
  belongs_to :bank_detail

  validates :inflow_amount, :outflow_amount, presence: true
  scope :approved, -> { where(is_approved: true) }

  def credit_limit
    maximum_possible_emi * term_in_months
  end

  def system_recommendation
    creditibility_score > 2 ? 'Approve' : 'Reject'
  end

  def self.fetch_loan_application(loan_id)
    select('loan_applications.*,
                            users.email AS email,
                            users.pan_card AS pan_card,
                            users.aadhar_number AS aadhar_number,
                            bank_details.account_number AS account_number,
                            bank_details.ifsc_number AS ifsc_number')
                   .joins(bank_detail: :user)
                   .find(loan_id)
  end

  private

  def maximum_possible_emi
    (inflow_amount / 2 - outflow_amount).to_f
  end

  def term_in_months
    case maximum_possible_emi.to_i
    when 0..5_000
      6
    when 5_001..10_000
      12
    when 10_001..20_000
      18
    else
      24
    end
  end
end
