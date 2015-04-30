app = require '../app'

React = require 'react'
tagsListComponent = require '../react/basecamp/tagsList'
tagsButtonComponent = require '../react/basecamp/tagsButton'

updateTodo = (todoId) ->
  app.helpers.getTags todoId
  .then (tagsList) ->

    tagsIndex = app.helpers.getAllTags().tagsIndex
    React.render tagsListComponent( { tagsList, tagsIndex } ), app.todoContainers[todoId].list

    unless tagsList?.length > 0

      if location.href.match /todos\/\d+/i
        dataBehavior = 'expandable expand_exclusively'
      else
        dataBehavior = 'expandable expand_exclusively hover_content'

      buttonData = {
        todoId: todoId
        styles: { visibility: 'visible', zIndex: 996 } if location.href.match /todos\/\d+/i

        dataBehavior

        onSaveTag: app.actions.onSaveTag
        onAssignTag: app.actions.onAssignTag

        getAllTags: app.helpers.getAllTags

        onPopupClose: ->
          updateTodo todoId
      }

    React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].button

  .catch (error) ->
    console.log error

module.exports = updateTodo
