app = require '../app'

React = require 'react'
tagsListComponent = require '../react/basecamp/tagsList'
tagsButtonComponent = require '../react/basecamp/tagsButton'

{ span } = React.DOM

updateTodo = (todoId) ->
  app.helpers.getTags todoId
  .then (tagsList) ->

    buttonData = {
      todoId: todoId

      dataBehavior: 'expandable expand_exclusively'

      onSaveTag: app.actions.onSaveTag
      onAssignTag: app.actions.onAssignTag
      onDeleteTag: app.actions.onDeleteTag
      getAllTags: app.helpers.getAllTags

      activeTags: tagsList

      onPopupClose: ->
        updateTodo todoId
    }

    unless tagsList?.length > 0
      buttonData.content = span {}, 'Tags'
      buttonData.classes = 'pill blank'

      if location.href.match /todos\/\d+/i
        buttonData.styles = { visibility: 'visible', zIndex: 996, marginLeft: 4 }
        React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].button
      else
        buttonData.dataBehavior += ' hover_content'
        buttonData.styles = { visibility: 'hidden' }
        React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].button

    if tagsList?.length > 0
      buttonData.styles = { visibility: 'visible' }
      tagsIndex = app.helpers.getAllTags().tagsIndex
      buttonData.content = tagsListComponent { tagsList, tagsIndex }

      React.render tagsButtonComponent( buttonData ), app.todoContainers[todoId].list
      React.render span(), app.todoContainers[todoId].button

  .catch (error) ->
    console.log error

module.exports = updateTodo
