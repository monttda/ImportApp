class OperationsController < ApplicationController

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

end
