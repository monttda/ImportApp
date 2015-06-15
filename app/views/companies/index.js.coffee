# Add the companies collapsables
$('#companies').html("<%= j(render 'companies_collapse', companies: @companies) %>")
               .on 'click', '.company_header', (e) ->

# On click of the header if the content of the collapse is empty
# fill it
$('#accordion').on 'click', '.company_header', (e)->
  panel = $(this).closest('.panel')
  table = $(panel).find('.table')
  opened = $(table).data("opened")
  if (opened != 1)
    companyId = $(table).data("company")
    filter = $(table).data("filter")
    nextpage = $(table).data("nextpage")
    $(table).data("opened",1)
    $.get("/companies/"+companyId+"/operations/for_company/?filter="+filter+"&page="+nextpage)

# Get more operations form the database
$('#accordion').on 'click', '.more_operations', (e)->
  panel = $(this).closest('.panel')
  table = $(panel).find('.table')
  companyId = $(table).data("company")
  filter = $(table).data("filter")
  nextpage = $(table).data("nextpage")
  $.get("/companies/"+companyId+"/operations/for_company/?filter="+filter+"&page="+nextpage)

# Empty the tables of each company and set the data attributes for
# next searches
$('#apply_filters').on 'click', (e) ->
  refresh_companies()

#download the csv file
$('.import_csv').on 'click', (e) ->
  panel = $(this).closest('.panel')
  table = $(panel).find('.table')
  companyId = $(table).data("company")
  filter = $(table).data("filter")
  window.location.href = "/companies/"+companyId+"/operations/csv_for_company.csv/?filter="+filter
