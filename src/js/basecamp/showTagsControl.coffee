app = require '../app'

React = require 'react'

container = null

module.exports = (section) ->
  if section
    container = document.createElement 'div'
    container.className = 'taist'
    section.appendChild container

  if container
    tagsControl = require '../react/basecamp/tagsControl'

    renderData =
      getAllTags: app.helpers.getAllTags
      onTagFilter: app.actions.onTagFilter
      activeTags: [ app.options.filteredTag ] if app.options.filteredTag
      onToggleFilter: app.actions.onToggleFilter
      isFilterExpanded: app.options.isFilterExpanded

    React.render tagsControl(renderData), container
