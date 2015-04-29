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

    app.helpers.loadAllTags()
    .then (tagsIndex) ->

      app.observer.waitElement 'li.todo.show', (todoElem) ->
        unless todoElem.querySelector '.taist'
          id = todoElem.id

          tagsButton = document.createElement 'span'

          if location.href.match /todos\/\d+/i
            tagName = 'div'
            listPrevElem = '.wrapper'
            buttonStyles = visibility: 'visible', zIndex: 996
            dataBehavior = 'expandable expand_exclusively'
          else
            tagName = 'span'
            listPrevElem = '.content'
            dataBehavior = 'expandable expand_exclusively hover_content'

          tagsButton.style.position = 'relative'

          container = document.createElement tagName
          container.className = 'taist'
          # app.todoContainers[id] = container
          insertAfter container, todoElem.querySelector listPrevElem

          app.helpers.getTags id
          .then (tagsList) ->
            React.render tagsListComponent( { tagsList, tagsIndex } ), container

            unless tagsList?.length > 0
              insertAfter tagsButton, todoElem.querySelector('form.edit_todo span')
              buttonData = {
                todoId: id
                styles: buttonStyles
                dataBehavior

                onSaveTag: app.actions.onSaveTag
                onAssignTag: app.actions.onAssignTag

                getAllTags: app.helpers.getAllTags
              }
              React.render tagsButtonComponent( buttonData ), tagsButton
          .catch (error) ->
            console.log error

module.exports = addonEntry
