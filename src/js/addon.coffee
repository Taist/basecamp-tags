app = require './app'

insertAfter = require './helpers/insertAfter'

React = require 'react'
tagsListComponent = require './react/basecamp/tagsList'
tagsButtonComponent = require './react/basecamp/tagsButton'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.observer = new DOMObserver()

    app.observer.waitElement 'li.todo.show', (todoElem) ->
      id = todoElem.id

      tagsButton = document.createElement 'span'

      if location.href.match /todos\/\d+/i
        tagName = 'div'
        listPrevElem = '.wrapper'
      else
        tagName = 'span'
        listPrevElem = '.content'
        tagsButton.style.visibility = 'hidden'
        tagsButton.setAttribute 'data-behavior', 'hover_content'
        tagsButton.setAttribute 'data-hovercontent-strategy', 'visibility'

      container = document.createElement tagName
      # app.todoContainers[id] = container
      insertAfter container, todoElem.querySelector listPrevElem
      tagsList = app.helpers.getTags id
      React.render tagsListComponent( { tagsList } ), container

      tagsButton.innerHTML = 'TAGS'
      todoElem.querySelector('form.edit_todo span').appendChild tagsButton
      React.render tagsButtonComponent(), tagsButton




module.exports = addonEntry
