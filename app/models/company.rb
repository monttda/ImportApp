class Company < ActiveRecord::Base
  has_many :operations

  validates_presence_of :name

  # Returns all the information needed to be displayed for each company
  # in a hash for a given month.
  #
  # @param [Integer] month the number representing the month for which the
  #                  company information is wanted
  #
  # @return [Array<Hash>] companies_info information for each company.
  # * :text [String]  String containing companies data for display.
  # :id [number] company's identifier
  def self.display_information()
    companies_info = []
    Company.order(:name).each do |company|
      company_info= {}
      company_operations = company.operations
      month_operations =
        company_operations.where("extract(month from operation_date) = ? AND "\
                                 "extract(year from operation_date) = ?",
                                 Date.today.month,
                                 Date.today.year  )
      name = company.name
      accepted_operations =
        company_operations.where(status: 'accepted').size
      avg_amount_of_operations =
        company_operations.average(:amount).try(:round, 2)
      avg_amount_of_operations ||= 0
      highest_operation = month_operations.maximum(:amount).try(:round, 2)
      highest_operation ||= 0
      num_of_operations = company_operations.size
      company_info[:id] = company.id
      company_info[:text] = I18n.t("companies.header_info",
                              name: name ,
                              operations_num: num_of_operations ,
                              avg_amount: avg_amount_of_operations ,
                              highest_operation: highest_operation ,
                              accepted_operation: accepted_operations )

      companies_info << company_info
    end
    companies_info
  end
end
