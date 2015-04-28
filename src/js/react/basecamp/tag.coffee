React = require 'react'

{ span } = React.DOM

Tag = React.createFactory React.createClass
  render: ->
    span {
      style:
        background: '#e2e9f8'
        fontSize: '12px'
        lineHeight: '16px'
        padding: '0 7px'
        border: '1px solid transparent'
        whiteSpace: 'nowrap'
        display: 'inline-block'
        borderRadius: 12
        marginRight: 4
        cursor: 'pointer'
    }, @props.name

module.exports = Tag
