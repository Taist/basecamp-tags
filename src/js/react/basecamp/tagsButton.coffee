React = require 'react'

{ span, a, div } = React.DOM

Styles = require './styles'
BasecampPopup = require './popup'

TagsButton = React.createFactory React.createClass
  onClick: ->
    console.log 'onclick'

  preventDefault: (event) ->
    event.preventDefault()
    event.stopPropagation()

  render: ->
    span {
        style: Styles.get 'dummy', {
          visibility: 'hidden'
          marginLeft: 4
        }, @props.styles
        className: 'pill blank has_balloon exclusively_expanded'
        'data-behavior': @props.dataBehavior
        'data-hovercontent-strategy': 'visibility'
        onClick: @onClick
        # onMouseEnter: @preventDefault
        # onMouseLeave: @preventDefault
        # onMouseOver: @preventDefault
        # onMouseOut: @preventDefault
        # onMouseMove: @preventDefault
      },
        a {
          href: '#'
          'data-behavior': 'expand_on_click'
        },
          span {}, 'Tags'

        BasecampPopup {}

module.exports = TagsButton
