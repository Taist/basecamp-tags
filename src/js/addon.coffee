app = require './app'

Q = require 'q'

extend = require 'react/lib/Object.assign'

insertAfter = require './helpers/insertAfter'

basecampTags = require './basecamp/basecampTags'
basecampTags.init app

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.elementObserver = new DOMObserver()

    Q.all [
      app.exapi.getUserData 'options'
      app.helpers.loadAllTags()
    ]

    .spread (options) ->
      extend app.options, options

      app.helpers.loadTodosIndex()

    .then () ->
      app.helpers.filterTodos()

      app.elementObserver.waitElement '.sheet_body', ->
        app.helpers.loadAllTags()
        .then () ->
          app.helpers.loadTodosIndex()

      app.elementObserver.waitElement 'section.todos', (section) ->
        require('./basecamp/showTagsControl')(section)

      app.elementObserver.waitElement 'li.todo.show', (todoElem) ->
        unless todoElem.querySelector '.taist'
          todoId = todoElem.id

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

          app.todoContainers[todoId] = { list: container, button: tagsButton }

          app.basecamp.updateTodo todoId

    .catch (err) ->
      console.log err

module.exports = addonEntry
