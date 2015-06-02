app = require '../app'

React = require 'react'

container = null

module.exports = (section) ->
  console.log 'filter', section

  if section
    container = document.createElement 'div'
    container.className = 'taist'
    section.appendChild container

  if container
    tagsControl = require '../react/basecamp/tagsControl'

    renderData =
      getAllTags: app.helpers.getAllTags

    React.render tagsControl(renderData), container
