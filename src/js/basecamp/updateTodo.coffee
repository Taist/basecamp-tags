app = require '../app'

React = require 'react'
tagsListComponent = require '../react/basecamp/tagsList'
tagsButtonComponent = require '../react/basecamp/tagsButton'

{ span } = React.DOM

isLog = false

updateTodo = (todoId) ->
  app.helpers.getTags todoId
  .then (tagsList) ->
    if isLog
      console.log tagsList

    unless app.todoContainers[todoId]
      return false

    buttonData = {
      todoId: todoId

      dataBehavior: 'expandable expand_exclusively'

      onSaveTag: app.actions.onSaveTag
      onAssignTag: app.actions.onAssignTag
      onDeleteTag: app.actions.onDeleteTag
      getAllTags: app.helpers.getAllTags

      activeTags: tagsList

      onPopupClose: ->
        console.log todoId
        isLog = true
        updateTodo todoId
    }

    unless tagsList?.length > 0
      buttonData.classes = 'pill blank'

      if location.href.match /todos\/\d+/i
        buttonData.styles = { visibility: 'visible', zIndex: 996, marginLeft: 4 }
        React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].button
      else
        buttonData.styles = { visibility: 'visible' }
        React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].button

      React.render span(), app.todoContainers[todoId].list

    if tagsList?.length > 0
      buttonData.styles = { visibility: 'visible' }
      tagsIndex = app.helpers.getAllTags().tagsIndex

      React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].list
      React.render span(), app.todoContainers[todoId].button

  .catch (error) ->
    console.log error

module.exports = updateTodo
