React = require 'react'

{ span } = React.DOM

Styles = require './styles'

Tag = React.createFactory React.createClass
  render: ->
    span {
      style: Styles.get 'tag', { marginRight: 4 }
    }, @props.name

module.exports = Tag
