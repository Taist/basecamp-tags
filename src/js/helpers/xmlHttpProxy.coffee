_responseHandlers = []
_listening = false

module.exports =
  onRequestFinish: (responseHandler) ->
    _responseHandlers.push responseHandler
    if not _listening
      _listening = true
      _listenToRequests()

_listenToRequests = ->
  originalSend = XMLHttpRequest.prototype.send

  XMLHttpRequest.prototype.send = ->
    # right way with onreadystatechange redifinition doesn't work for basecamp
    _handleResponseByTimer @
    originalSend.apply @, arguments

_handleResponseByTimer = (request) ->
    if request.responseURL is ''
      setTimeout ->
        _handleResponseByTimer request
      , 200
    else
      finished = request.readyState is 4
      if finished
        for handler in _responseHandlers
          handler request


_listenForRequestFinish = (request) ->
  originalOnReadyStateChange = request.onreadystatechange
  request.onreadystatechange = ->
    finished = request.readyState is 4
    if finished
      for handler in _responseHandlers
        handler request

    originalOnReadyStateChange?.apply request, arguments
