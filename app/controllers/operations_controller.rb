class OperationsController < ApplicationController
  @@per_page = 5

  before_action :fetch_operations, only: [:for_company,:csv_for_company]

  def import
    file = params[:file]
    case File.extname(file.tempfile)
    when '.csv'

      Rails.logger.silence do
        options = {:chunk_size => ImportCsvJob::CHUNK_SIZE}
        operations = SmarterCSV.process(file.tempfile, options)
        @import_job = Delayed::Job.enqueue(ImportCsvJob.new(operations,100))
    end
    else
      flash.now[:error] = "The file extension is incorrect please provide a valid "\
                      ".csv file"
    end
  end


  # GET /company/:company_id/for_company
  #
  # @return [Operation::ActiveRecord_Relation ] @operations_by_company:
  # => collection of Operations to be rendered in the view
  # @return [Boolean] @more_to_show: indicates if there is there are operations
  # => that haven't been fetch yet due to the pagination
  # @return [Integer] @next_page: indicates the next page to be fetch
  # => when the action is called again
  # @return [String] @table_id: Identifier of the comapanies's table of
  # => operationin the DOM
  # @return [Hash<Integer, String>] @formatted_categories_per_operation:
  # => Contains the categories names stored under each operatio key
  def for_company
    page_number = params[:page].present? ? params[:page].to_i : 1
    @operations_by_company = @operations_by_company.page(page_number)
                                                   .per(@@per_page)
    @formatted_categories_per_operation = {}
    @operations_by_company.each do |operation|
      categories_names = []
      operation.categories.each do |category|
        categories_names << category.name
      end
      @formatted_categories_per_operation[operation.id]=
        categories_names.join("; ")
    end

    @more_to_show =
      @operations_by_company.total_count > (page_number * @@per_page) ?
        true : false
    @next_page = @more_to_show ? page_number + 1 : page_number
    @table_id = "company_#{params[:company_id]}_table"
  end

  def csv_for_company
    filter = params[:filter]
    company_name = Company.find(params[:company_id]).name
    csv_name = filter.present? ?
                 "#{company_name}_operations_filtered_by_#{filter}.csv" :
                 "#{company_name}_operations.csv"
    respond_to do |format|
      format.csv { send_data to_csv ,filename: csv_name}
    end
  end
  private

    # Retrieves data from the params and used them to fetch operations from
    # the database
    #
    def fetch_operations
      filter = params[:filter]
      company_id = params[:company_id]
      @operations_by_company = Operation.for_company(filter, company_id)
    end

    def to_csv
      CSV.generate(options = {}) do |csv|
        column_names = ["company","invoice_num","invoice_date","operation_date",
                        "amount","reporter","notes","status","kind"
                       ]
        csv << column_names
        @operations_by_company.each do |operation|
          csv << operation.to_array
        end
      end
    end
end
