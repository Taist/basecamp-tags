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

      if location.href.match /todos\/\d+/i
        tagName = 'div'
        prevElem = '.wrapper'
      else
        tagName = 'span'
        prevElem = '.content'

      container = document.createElement tagName
      # app.todoContainers[id] = container

      insertAfter container, todoElem.querySelector prevElem

      tagsList = app.helpers.getTags id
      React.render tagsListComponent( { tagsList } ), container


module.exports = addonEntry
