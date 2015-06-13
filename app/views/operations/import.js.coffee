<% if flash.now[:error].nil? %>
  $('.well').show()
  $('.progress-bar').css('width', '0%').text '0%'
                    .removeClass 'progress-bar-danger'
                    .addClass 'active'
  $('.progress-status').removeClass 'text-danger'
  $('#send_csv').removeClass 'hidden'
  $('.loader_wrapper').empty()
  interval = setInterval((->
    $.ajax
      url: "/progress-job/<%=@import_job.id%>",
      success: (job) ->
        stage = undefined
        progress = undefined
        # If there are errors
        if job.last_error != null
          $('.progress-status').addClass('text-danger').text job.progress_stage
          $('.progress-bar').addClass 'progress-bar-danger'
          $('.progress').removeClass 'active'
          clearInterval interval
          $('#send_csv').removeClass 'disabled'
        # Upload stage
        if job.progress_stage != null
          stage = job.progress_stage
          progress = job.progress_current / job.progress_max * 100
        else
          progress = 0
          stage = 'Waiting to be processed'
        # In job stage
        if progress != 0
          $('.progress-bar').css('width', progress + '%').text progress + '%'
        $('.progress-status').text stage
        return
      error: ->
        # Job is no loger in database which means it finished successfuly
        $('.progress').removeClass 'active'
        $('.progress-bar').css('width', '100%').text '100%'
        #$('.progress-status').text 'Successfully imported!'
        clearInterval interval
        $('#send_csv').removeClass 'disabled'
        return
    return
  ), 100)
<% else %>
  $('.errors_wrapper').html("<%=flash.now[:error]%>")
  $('#send_csv').removeClass 'hidden'
                .removeClass 'disabled'
  $('.loader_wrapper').empty()
<% end %>
