React = require 'react'

{ span, label, b, footer, a, div } = React.DOM

Styles = require './styles'

BasecampPopup = React.createFactory React.createClass
  render: ->
    span { className: 'balloon right_side expanded_content' },
      span { className: 'arrow' }
      span { className: 'arrow' }
      label {},
        b {}, 'Assign tags on this to-do'
        div {}, '1'
        div {}, '2'
        div {}, '3'
        div {}, '4'
        div {}, '5'
      footer {},
        a { href: '#', className: 'decorated' }, 'Add new tag'

module.exports = BasecampPopup
