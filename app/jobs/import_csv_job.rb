require "csv_file_uploader"
class ImportCsvJob < ProgressJob::Base


  CHUNK_SIZE = 1000
  def initialize(file_name , progress_max=100)
    super progress_max: progress_max
    @file_name = file_name

  end

  def perform
    companies_hash = Company.pluck(:name,:id).to_h
    failed = 0
    success = 0
    processed =0
    uploader = CsvFileUploader.new
    uploader.retrieve_from_store!(@file_name)
    update_stage('Processing the CSV')
    csv_file = File.open(uploader.file.to_file)
    options = {:chunk_size => ImportCsvJob::CHUNK_SIZE}
    operations = SmarterCSV.process(csv_file, options)
    csv_file.close
    uploader.remove!
    if operations.size > 0
      total_operations =
        ((operations.size()-1)* CHUNK_SIZE) + operations.last.size
      value_per_operation = @progress_max/total_operations.to_f
    else
      total_operations= 0
      value_per_operation = 0
    end


      operations.each do |operations_chunk|
      operations_chunk.each do |operation|
        company_name = operation.delete(:company)

        operation_invoice_num = operation[:invoice_num]
        #Verify if this record has categories
        if (companies_hash.has_key?(company_name) &&
            operation[:kind].present? )
          categories_names = operation.delete(:kind).split(';')
          company_id_hash = {company_id: companies_hash[company_name]}
          # Verify and Format dates
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
                Category.find_or_initialize_by(name: category_name.downcase)
              new_operation.categories << category
            end
            if new_operation.save
              success += 1
            else
              failed += 1
            end
          else
            failed+=1
          end
        else
          failed+=1
        end
      end
      processed+= operations_chunk.size
      update_stage_progress(
        "Processed operations: #{processed}/ #{total_operations} |  "\
        "Succeded: #{success} | Failed: #{failed}",
        step: 5* operations_chunk.size())
    end
    # delete the file
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
