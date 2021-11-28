require 'net/http'

class UserFullContact < ApplicationService
  VERB_MAP = {
    get: Net::HTTP::Get
  }.with_indifferent_access
  RETRY_COUNT = 3
  URL = 'https://api.fullcontact.com/v2/person.json'.freeze

  attr_accessor :retry_count

  def call
    response = fetch_full_contact
    if response.code != '200'
      example_data
    else
      JSON.parse(response.body)
    end
  end

  private

  def uri
    @uri ||= URI(URL)
  end

  def req_params
    { email: @options[:email] }
  end

  def fetch_full_contact
    uri.query = URI.encode_www_form(req_params)

    Net::HTTP.get_response(uri)
  rescue StandardError => e
    Rails.logger.error e
  end

  def example_data
    YAML.load_file('config/sample_response.yml')
  end
end
