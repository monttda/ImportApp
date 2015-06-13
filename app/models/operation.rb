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

  

end
