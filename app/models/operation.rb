class Operation < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :categories

  validates_presence_of :invoice_num, :invoice_date, :amount, :operation_date, :status
  validates_numericality_of :amount, greater_than: 0
  validates_uniqueness_of :invoice_num
  validate :has_categories?

  # Validates if an operation instance has an associated category
  def has_categories?
    errors.add(:categories,  "An operation must have some categories.") if self.categories.empty?
  end

  # Returns the operations_for_company that belongs to a given company ordered
  # by the operation_date attribute if a filter is given it will be applied to
  # the operations status, associated categories names, invoice_num and reporter
  # attributes.
  #
  # @param [String] filter: String to be used to filter the operations
  # @param [Integer] company_id: identifier of the company
  #
  # @return [Operation::ActiveRecord_Relation ] the collection of operations
  #         ordered and filtered if any was given
  def self.for_company(filter, company_id)
    operations_for_company = Operation.where( company_id: company_id)
                                      .includes(:categories)
    if filter.present?
      filter = "%#{filter}%"
      operations_for_company =
        operations_for_company.joins{categories}
                              .where{ ( (status =~ my{filter} ) |
                                        (categories.name =~ my{filter}) |
                                        (invoice_num =~ my{filter}) |
                                        (reporter =~ my{filter})
                                      )
                                    }
    end
    operations_for_company.order(:operation_date)
  end

  # Returns the information of an operation as an array
  # @return <Array>
  def to_array
    [  self.company.name,
       self.invoice_num,
       self.invoice_date,
       self.operation_date,
       self.reporter,
       self.notes,
       self.status,
       self.categories.pluck(:name).join(";")
    ]
  end
end
