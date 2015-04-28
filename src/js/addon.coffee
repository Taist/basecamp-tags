app = require './app'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.observer = new DOMObserver()

    app.observer.waitElement 'li.todo.show', (todo) ->
      console.log 'todo'

module.exports = addonEntry
