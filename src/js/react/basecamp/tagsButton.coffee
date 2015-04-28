React = require 'react'

{ span } = React.DOM

Styles = require './styles'

TagsButton = React.createFactory React.createClass
  render: ->
    span {
      style: Styles.get 'tag', {
        margin: 0
        marginLeft: 4
        lineHeight: '15px'
        backgroundColor: 'white'
        border: '1px solid #ddd'
        color: '#999'
      }
    }, 'Tags'

module.exports = TagsButton
