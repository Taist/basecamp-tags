app = require './app'

insertAfter = require './helpers/insertAfter'

React = require 'react'
tagsListComponent = require './react/basecamp/tagsList'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.observer = new DOMObserver()

    app.observer.waitElement 'li.todo.show', (todoElem) ->
      id = todoElem.id
      container = document.createElement 'span'
      # app.todoContainers[id] = container

      tagsList = {}
      React.render tagsListComponent( tagsList ), container

      insertAfter container, todoElem.querySelector '.content'

module.exports = addonEntry
