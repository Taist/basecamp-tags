React = require 'react'

module.exports = (section) ->
  tagsControl = require '../react/basecamp/tagsControl'

  container = document.createElement 'div'
  container.className = 'taist'
  section.appendChild container

  React.render tagsControl( {} ), container
