class User < ApplicationRecord
  # here we are assuming user has only one bank account
  has_one :bank_detail
end
