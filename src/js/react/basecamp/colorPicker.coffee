React = require 'react'

{ div } = React.DOM

colors = "#fc9,#c9c,#9cf,#cfc,#cf9,#9cc,#c9f,#fcc,#f9c,#cc9,#9fc,#ccf".split(',')

ColorPicker = React.createFactory React.createClass
  getInitialState: ->
    activeColor: null

  componentDidMount: ->
    @setState activeColor: @props.activeColor ? colors[Date.now()%colors.length]

  componentWillReceiveProps: (nextProps) ->
    @setState activeColor: nextProps.activeColor

  onSelectColor: (color) ->
    @setState activeColor: color, =>
      @props.onSelectColor? color

  render: ->
    div {},
      colors.map (color, idx) =>
        div {
          key: color
          onClick: => @onSelectColor color
          style:
            cursor: 'pointer'
            boxSizing: 'border-box'
            opacity: if color is @state.activeColor then 1 else 0.4
            border: if color is @state.activeColor then '1px solid black' else 'none'
            marginTop: 4
            marginLeft: if idx > 0 then 2 else 0
            position: 'relative'
            display: 'inline-block'
            width: 11
            height: 11
            background: color
        }

module.exports = ColorPicker
