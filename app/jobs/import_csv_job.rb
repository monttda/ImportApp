class ImportCsvJob < ProgressJob::Base
  CHUNK_SIZE = 1000
  def initialize(operations , progress_max)
    super progress_max: progress_max
    @operations = operations

  end

  def perform
    companies_hash = Company.pluck(:name,:id).to_h
    failed = 0
    success = 0
    processed =0

    existing_invoice_num = {}
    update_stage('Processing the CSV')
    if @operations.size > 0
      total_operations =
        ((@operations.size()-1)* CHUNK_SIZE) + @operations.last.size
      value_per_operation = @progress_max/total_operations.to_f
    else
      total_operations= 0
      value_per_operation = 0
    end
    @operations.each do |operations_chunk|
      operations_array = []
      operations_chunk.each do |operation|
        company_name = operation.delete(:company)

        operation_invoice_num = operation[:invoice_num]
        if (companies_hash.has_key?(company_name) &&
            !existing_invoice_num.has_key?(operation_invoice_num) &&
            operation[:kind].present? )
          categories_names = operation.delete(:kind).split(';')
          existing_invoice_num [operation_invoice_num] = true
          company_id_hash = {company_id: companies_hash[company_name]}
          [:invoice_date, :operation_date].each do |key|
            operation[key] =
              proccess_date(operation[key]) if operation[key].present?
          end
          new_operation = Operation.new(operation.merge(company_id_hash))
          new_operation.valid?
          if new_operation.errors.size <= 1
            new_operation.errors.clear
            categories_names.each do |category_name|
              category =
                Category.find_or_create_by(name: category_name.downcase)
              new_operation.categories << category
            end
            operations_array << new_operation
          else
            failed+=1
          end
        else
          failed+=1
        end
      end
      processed+= operations_chunk.size
      results = Operation.import(operations_array, validate: false)
      success += operations_array.size - results.failed_instances.size
      failed += results.failed_instances.size
      update_stage_progress(
        "Processed operations: #{processed}/ #{total_operations} |  "\
        "Succeded: #{success} | Failed: #{failed}",
        step: value_per_operation* operations_chunk.size())
    end
    update_stage_progress(
      "Finished!   Processed operations: #{processed}/ #{total_operations} |  "\
      "Succeded: #{success} | Failed: #{failed}" )

  # Sleep to give time to the progress bar to show the final information
  sleep(5)
  end

  # Takes a string representing a date and if it is in  MM/DD/YYYY, YYYY-MM-DD
  # or  DD-MM-YYYY it returs it in Date format, if it is not in those formarts
  # it returns nil
  #
  # @param [String] string_date: Date to be converted into Date format
  #
  def proccess_date(string_date)
  processed_date = nil
  split_by_minus= string_date.split('-')
  if split_by_minus.size > 2
    if split_by_minus[0].size < 4
      processed_date =  Date.strptime(string_date, '%d-%m-%Y')
    else
      processed_date = Date.strptime(string_date, '%Y-%m-%d')
    end
  else
    split_by_slash =  string_date.split('/')

    if split_by_slash.size > 2
      processed_date = Date.strptime(string_date, '%m/%d/%Y')

    end
  end
  processed_date

  rescue ArgumentError
    return nil
  end
end
