React = require 'react'

{ div } = React.DOM

getElementRect = require '../../helpers/getElementRect'

TagsControl = React.createFactory React.createClass
  controlWidth: 200

  getInitialState: ->
    container = getElementRect document.querySelector 'section.todos'

    positionLeft: container.left + container.width - @controlWidth
    initialTop: container.top
    positionTop: container.top

  componentDidMount: () ->
    window.addEventListener 'scroll', @onScroll, false

  componentWillUnmount: () ->
    window.removeEventListener 'scroll', @onScroll, false

  onScroll: () ->
    @setState positionTop: Math.max 12, @state.initialTop - document.body.scrollTop

  render: ->
    div {
      style:
        position: 'fixed'
        top: @state.positionTop or 0
        left: @state.positionLeft if @state.positionLeft
        width: @controlWidth
        border: '1px solid silver'
        padding: 8
        fontFamily: 'arial, sans-serif'
        fontSize: 13
        background: 'white'
        zIndex: 1001
    },
      div {className: 'tagsControl'}, 'TAGS CONTROL'

module.exports = TagsControl
