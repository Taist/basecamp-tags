React = require 'react'
extend = require 'react/lib/Object.assign'

{ div, span } = React.DOM

getElementRect = require '../../helpers/getElementRect'

TagsList = require './tagsList'

TagsControl = React.createFactory React.createClass
  paddingTop: 24
  paddingRight: -24

  controlWidth: 200

  getInitialState: ->
    container = getElementRect document.querySelector 'section.todos'

    positionLeft: container.left + container.width - @controlWidth - @paddingRight
    initialTop: container.top
    positionTop: Math.max @paddingTop, container.top - document.body.scrollTop

    tagsList: []
    tagsIndex: {}
    isPopupVisible: false
    activeTags: null

  updateTagsList: () ->
    if @props.getAllTags?
      allTags = @props.getAllTags()
      @setState extend {}, allTags, activeTags: (@props.activeTags or [])

  componentWillReceiveProps: (nextProps) ->
    console.log 'componentWillReceiveProps'
    @updateTagsList()

  componentDidMount: () ->
    window.addEventListener 'scroll', @onScroll, false
    @updateTagsList()

  componentWillUnmount: () ->
    window.removeEventListener 'scroll', @onScroll, false

  onScroll: () ->
    @setState positionTop: Math.max @paddingTop, @state.initialTop - document.body.scrollTop

  onClickByTag: (tagId) ->
    @setState activeTags: [ tagId ]

  render: ->
    div {
      style:
        position: 'fixed'
        top: @state.positionTop or 0
        left: (@state.positionLeft) if @state.positionLeft
        zIndex: 2
    },
      span { className: 'balloon', style: width: @controlWidth },
        div { style: position: 'relative', marginBottom: 8 },
          span { style: fontWeight: 'bold' }, 'Tags filter'
        div {},
          TagsList {
            tagsList: @state.tagsList
            tagsIndex: @state.tagsIndex
            activeTags: @state.activeTags
            onClick: @onClickByTag
          }

module.exports = TagsControl
