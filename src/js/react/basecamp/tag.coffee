React = require 'react'

{ span } = React.DOM

Styles = require './styles'

Tag = React.createFactory React.createClass
  render: ->
    span {
      key: @props.id
      style: Styles.get 'tag', { marginRight: 4, marginBottom: 2 }
    }, @props.name

module.exports = Tag
