React = require 'react'
extend = require 'react/lib/Object.assign'

{ div } = React.DOM

Tag = require './tag'

TagsList = React.createFactory React.createClass
  render: ->
    if @props.tagsList?.length > 0
      div { style: display: 'inline-block', marginRight: -4 },
        @props.tagsList.map (tagId) =>
          if @props.tagsIndex?[tagId]?
            isInactive = @props.activeTags?
            isInactive = false if @props.activeTags?.indexOf(tagId) > -1
            onClick = @props.onClick if typeof @props.onClick is 'function'
            Tag extend {}, @props.tagsIndex[tagId], { isInactive, onClick }
          else
            null
    else
      null

module.exports = TagsList
