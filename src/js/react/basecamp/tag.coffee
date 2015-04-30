React = require 'react'

{ span } = React.DOM

Styles = require './styles'

Tag = React.createFactory React.createClass
  onClick: ->
    @props.onClick?(@props.id, not @props.isInactive)

  render: ->
    opacity = if @props.isInactive then 0.4 else 1
    background = @props.color ? '#e2e9f8'
    span {
      key: @props.id
      style: Styles.get 'tag', { marginRight: 4, marginBottom: 2, opacity, background }
      onClick: @onClick
    }, @props.name

module.exports = Tag
