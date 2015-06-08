class Company < ActiveRecord::Base
  has_many :operations

  validates_presence_of :name

  # Returns all the information needed to be displayed for each company
  # in a hash for a given month.
  #
  # @param [Integer] month the number representing the month for which the company information is wanted
  #
  # @return [Array<Hash>] companies_info information for each company.
  # * :text [String]  String containing companies data for display.
  # * :name [String] company's name
  def self.display_information()
    companies_info = []
    Company.order(:name).each do |company|
      company_info= {}
      company_operations = company.operations
      name = company.name
      accepted_operations =
        company_operations.where(status: 'accepted').size
      avg_amount_of_operations =
        company_operations.average(:amount)
      avg_amount_of_operations ||= 0
      highest_operation = company_operations.maximum(:amount)
      highest_operation ||= 0
      num_of_operations = company_operations.size
      company_info[:id] = company.id
      company_info[:name] = name
      company_info[:text] = "#{name} | Number of operations "\
                            "#{num_of_operations} | Average amount of "\
                            "operations: #{avg_amount_of_operations} | "\
                            "Highest operation: #{highest_operation} | "\
                            "Accepted operations: #{accepted_operations}         l"

      companies_info << company_info
    end
    companies_info
  end
end
