app = require './app'

Q = require 'q'

insertAfter = require './helpers/insertAfter'

updateTodo = require './basecamp/updateTodo'
updateTodo.init app

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.elementObserver = new DOMObserver()

    app.helpers.loadAllTags()
    .then () ->
      app.helpers.loadTodosIndex()
    .then () ->

      app.elementObserver.waitElement '.sheet_body', () ->
        app.helpers.loadAllTags()
        .then () ->
          app.helpers.loadTodosIndex()

      app.elementObserver.waitElement 'li.todo.show', (todoElem) ->
        unless todoElem.querySelector '.taist'
          id = todoElem.id

          tagsButton = document.createElement 'span'
          tagsButton.style.position = 'relative'
          tagsButton.className = 'taist'

          if location.href.match /todos\/\d+/i
            container = document.createElement 'div'
            container.className = 'taist'

            insertAfter container, todoElem.querySelector '.wrapper'

            insertAfter tagsButton, todoElem.querySelector 'form.edit_todo span'

          else
            container = document.createElement 'span'
            container.className = 'taist'

            nextElem = todoElem.querySelector 'form.edit_todo span'
            if nextElem
              parent = nextElem.parentNode

              parent.insertBefore container, nextElem

              parent.insertBefore tagsButton, nextElem

          app.todoContainers[id] = { list: container, button: tagsButton }

          app.helpers.updateTodo id

module.exports = addonEntry
