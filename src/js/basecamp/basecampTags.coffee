app = null

module.exports =
  init: (_app) ->
    app = _app
    app.basecamp.updateTodo = (todoId) ->
      require('./updateTodo') todoId

    app.basecamp.updateControl = () ->
      require('./showTagsControl')()
