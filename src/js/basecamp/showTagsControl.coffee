app = require '../app'

React = require 'react'

module.exports = (section) ->
  tagsControl = require '../react/basecamp/tagsControl'

  container = document.createElement 'div'
  container.className = 'taist'
  section.appendChild container

  renderData =
    getAllTags: app.helpers.getAllTags

  React.render tagsControl(renderData), container
