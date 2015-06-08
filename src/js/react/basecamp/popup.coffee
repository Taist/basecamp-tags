React = require 'react'

{ span, label, b, footer, div } = React.DOM

Styles = require './styles'

BasecampPopup = React.createFactory React.createClass
  render: ->
    span {
      className: 'balloon right_side expanded_content',
      style:
        right: -238
        width: 200
        display: 'block'
    },
      span { className: 'arrow' }
      span { className: 'arrow' }
      label {},
        b {}, @props.header
      div { style: marginTop: 12, marginBottom: 12 }, @props.content
      footer { style: textAlign: 'center' }, @props.footer

module.exports = BasecampPopup
