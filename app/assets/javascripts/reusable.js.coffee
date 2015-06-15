@refresh_companies = () ->  

  companiesTab = $('#companies')
  filterValue = $('#operations_filter').val()
  table = $(companiesTab).find('.table')
  $(companiesTab).find('.in').collapse('hide')
  $(table).data('filter',filterValue)
          .data('opened',0)
          .data('nextpage',1)
          .find('tbody').empty()
  $('.more_operations').removeClass('hidden')
