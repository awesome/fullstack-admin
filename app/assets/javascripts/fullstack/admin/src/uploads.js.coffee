#= require plupload
#= require plupload.settings
#= require jquery.plupload.queue
#= require plupload.html5
#= require plupload.flash

$(document).ready ->
  
  $('.photo-uploader').each ->
    uploader = $ this

    url   = uploader.data "url"
    session_key = uploader.data 'session-key'
    session_id  = uploader.data 'session-id'

    csrf_param = $("meta[name='csrf-param']").attr "content"
    csrf_token = $("meta[name='csrf-token']").attr "content"

    multipart_params = {}
    multipart_params[session_key] = session_id
    multipart_params[csrf_param]  = csrf_token

    uploader.pluploadQueue
      runtimes: 'html5, flash'
      url: url
      multipart_params: multipart_params

    uploader.pluploadQueue().bind 'FileUploaded', (up, fi, data) ->
      eval(data.response)

    uploader.pluploadQueue().bind 'UploadComplete', (up, fi, data) ->
      uploader.collapse('hide')
