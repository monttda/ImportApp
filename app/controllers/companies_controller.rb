class CompaniesController < ApplicationController

  # Dummy action to render the static content of the home site
  def home

  end

  # Return the information nedded for displaying the companies index
  # @return [Array<Hash>] @companies_info a hash containing all the information
  #                       that wants to be displayed
  def index
    @companies_info = Company.display_information
  end

end
