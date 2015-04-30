app = require './app'

insertAfter = require './helpers/insertAfter'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.init _taistApi

    DOMObserver = require './helpers/domObserver'
    app.observer = new DOMObserver()

    app.helpers.loadAllTags()
    .then () ->

      app.observer.waitElement 'li.todo.show', (todoElem) ->
        unless todoElem.querySelector '.taist'
          id = todoElem.id

          tagsButton = document.createElement 'span'

          if location.href.match /todos\/\d+/i
            tagName = 'div'
            listPrevElem = '.wrapper'
          else
            tagName = 'span'
            listPrevElem = '.content'

          container = document.createElement tagName
          container.className = 'taist'
          insertAfter container, todoElem.querySelector listPrevElem

          tagsButton.style.position = 'relative'
          insertAfter tagsButton, todoElem.querySelector('form.edit_todo span')

          app.todoContainers[id] = { list: container, button: tagsButton }

          require('./basecamp/updateTodo') id

module.exports = addonEntry
