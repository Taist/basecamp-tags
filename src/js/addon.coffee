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
      unless todoElem.querySelector '.taist'
        id = todoElem.id

        tagsButton = document.createElement 'span'

        if location.href.match /todos\/\d+/i
          tagName = 'div'
          listPrevElem = '.wrapper'
          buttonStyles =
            verticalAlign: 'top'
            marginTop: 3
        else
          tagName = 'span'
          listPrevElem = '.content'
          tagsButton.style.visibility = 'hidden'
          tagsButton.setAttribute 'data-behavior', 'hover_content'
          tagsButton.setAttribute 'data-hovercontent-strategy', 'visibility'

        container = document.createElement tagName
        container.className = 'taist'
        # app.todoContainers[id] = container
        insertAfter container, todoElem.querySelector listPrevElem
        tagsList = app.helpers.getTags id
        React.render tagsListComponent( { tagsList } ), container

        unless tagsList?.length > 0
          todoElem.querySelector('form.edit_todo span')?.appendChild tagsButton
          React.render tagsButtonComponent( { styles: buttonStyles } ), tagsButton




module.exports = addonEntry
