# frozen_string_literal: true

class LoanApplicationsController < ApplicationController
  SOCIAL_PROFILES = %w[linkedin twitter facebook].freeze
  http_basic_authenticate_with name: 'milaap', password: 'milaap', only: :index

  def dashboard
  end

  def index
    @loan_applications = LoanApplication.all
  end

  def new
    initialize_loan_application
    @user = User.new
  end

  def create
    ActiveRecord::Base.transaction do
      find_or_create_user
      find_or_create_bank_details
    end
    respond_to do |format|
      if @error
        initialize_loan_application
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan_application.errors, status: :unprocessable_entity }
      else
        find_or_create_loan_application_details
        fetch_and_update_score
        format.html { redirect_to loan_application_path(id: @loan_application.id), notice: "Loan Application was successfully created." }
        format.json { render :show, status: :created, location: @loan_application }
      end
    end
  end

  def show
    @loan_application = LoanApplication.fetch_loan_application(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :pan_card, :aadhar_number)
  end

  def bank_detail_params
    params.require(:user).require(:bank_details_attributes).permit!
  end

  def loan_application_params
    params.require(:loan_application).permit(:inflow_amount, :outflow_amount)
  end

  def initialize_loan_application
    @loan_application = LoanApplication.new
  end

  def find_or_create_user
    @user = User.find_or_create_by(user_params.slice(:email, :pan_card, :aadhar_number))
    @error = true if @user.errors.any?
  end

  def find_or_create_bank_details
    @user.bank_details_attributes = bank_detail_params

    return @error = true unless @user.save

    @bank_detail = @user.bank_details.last
  end

  def find_or_create_loan_application_details
    @bank_detail.loan_applications.build(loan_application_params)
    @bank_detail.save
    @loan_application = @bank_detail.loan_applications.last
  end

  def fetch_and_update_score
    response = UserFullContact.call(email: @user.email)
    update_score(response)
  end

  def update_score(response_data)
    score = (SOCIAL_PROFILES & response_data['socialProfiles'].map { |e| e['type'] }).count
    score += 1 if existing_loan_apps?
    @loan_application.update(creditibility_score: score)
  end

  def existing_loan_apps?
    @user.loan_applications.approved.count.positive?
  end
end
