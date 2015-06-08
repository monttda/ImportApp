class Company < ActiveRecord::Base
  has_many :operations

  validates_presence_of :name

  # Returns all the information needed to be displayed for each company
  # in a hash for a given month.
  #
  # @param [Integer] month the number representing the month for which the company information is wanted
  #
  # @return [Array<Hash>] companies_info information for each company.
  # * :accepted_operations [Integer]  number of accepted operations
  # * :avg_amount_of_operations [Float]  average amount of operations
  # * :highest_operation  [Float]  the highest value operation
  # * :name [String] company's name
  # * :num_of_operations [Integer]  the number of opertions in the company for a given month
  def self.display_information()
    companies_info = []
    Company.order(:name).each do |company|
      company_info= {}
      company_operations = company.operations
      company_info[:name] = company.name
      company_info[:accepted_operations] =
        company_operations.where(status: 'accepted')
      company_info[:avg_amount_of_operations] = 3
      company_info[:highest_operation] = company_operations.maximum(:amount)
      company_info[:num_of_operations] = company_operations.size
      companies_info << company_info
    end
    companies_info
  end
end
