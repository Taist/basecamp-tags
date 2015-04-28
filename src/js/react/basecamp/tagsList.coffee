React = require 'react'

{ div } = React.DOM

Tag = require './tag'

TagsList = React.createFactory React.createClass
  render: ->
    if @props.tagsList?.length > 0
      div { style: display: 'inline-block', marginRight: -4 },
        @props.tagsList.map (tagInfo) ->
          Tag tagInfo
    else
      null

module.exports = TagsList
