React = require 'react'

{ span } = React.DOM

AwesomeIcons = require '../taist/awesomeIcons'

Styles = require './styles'

Tag = React.createFactory React.createClass
  onClick: ->
    @props.onClick?(@props.tag.id, not @props.isInactive)

  onEdit: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @props.onEdit @props.tag

  render: ->
    opacity = if @props.isInactive then 0.6 else 1
    background = @props.tag.color ? '#e2e9f8'
    span {
      key: @props.tag.id
      style: Styles.get 'tag', { marginRight: 4, marginBottom: 2, opacity, background }
    },

      span { onClick: @onClick }, @props.tag.name

      if @props.onEdit?
        span {
          style:
            position: 'relative'
            marginLeft: 4
            marginRight: 12
        },
          span {
            onClick: @onEdit
            style:
              opacity: 0.6
              position: 'absolute'
              display: 'inline-block'
              width: 14
              height: 16
              backgroundImage: AwesomeIcons.getURL 'gear'
              backgroundSize: 'contain'
              backgroundRepeat: 'no-repeat'
              backgroundPosition: 'center'
          }

module.exports = Tag
