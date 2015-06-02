React = require 'react'
extend = require 'react/lib/Object.assign'

{ div, span } = React.DOM

getElementRect = require '../../helpers/getElementRect'

Tag = require './tag'
TagsList = require './tagsList'

AwesomeIcons = require '../taist/awesomeIcons'

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
    isFilterExpanded: false

  updateTagsList: () ->
    if @props.getAllTags?
      allTags = @props.getAllTags()
      @setState extend {}, allTags, activeTags: (@props.activeTags or []), isFilterExpanded: @props.isFilterExpanded

  componentWillReceiveProps: (nextProps) ->
    @updateTagsList()

  componentDidMount: () ->
    window.addEventListener 'scroll', @onScroll, false
    @updateTagsList()

  componentWillUnmount: () ->
    window.removeEventListener 'scroll', @onScroll, false

  onScroll: () ->
    @setState positionTop: Math.max @paddingTop, @state.initialTop - document.body.scrollTop

  onClickByTag: (tagId) ->
    @setState activeTags: (if @state.activeTags[0] is tagId then [] else [ tagId ]), =>
      @props.onTagFilter @state.activeTags[0]

  onToggleFilter: () ->
    @setState isFilterExpanded: !@state.isFilterExpanded, =>
      @props.onToggleFilter @state.isFilterExpanded

  render: ->
    div {
      style:
        position: 'fixed'
        top: @state.positionTop or 0
        left: (@state.positionLeft) if @state.positionLeft
        zIndex: 2
    },
      span { className: 'balloon', style: width: @controlWidth },
        div { style: position: 'relative'},
          span { style: fontWeight: 'bold' }, 'Tags filter'
          div {
            onClick: @onToggleFilter
            style:
              cursor: 'pointer'
              marginLeft: 6
              position: 'absolute'
              display: 'inline-block'
              width: 8
              height: '100%'

              backgroundSize: 'contain'
              backgroundRepeat: 'no-repeat'
              backgroundPosition: 'center'
              backgroundImage: AwesomeIcons.getURL(
                if @state.isFilterExpanded then 'chevron-up' else 'chevron-down'
              )
          }

          if !@state.isFilterExpanded and @state.activeTags?[0]?
            div {
              style:
                display: 'inline-block'
                marginLeft: 6 * 2 + 8 #width of expand icon with margins
            },
              Tag {
                tag: @state.tagsIndex[ @state.activeTags[0] ]
                isInactive: false
                onClick: @onClickByTag              
              }

        if @state.isFilterExpanded
          div { style: marginTop: 8 },
            TagsList {
              tagsList: @state.tagsList
              tagsIndex: @state.tagsIndex
              activeTags: @state.activeTags
              onClick: @onClickByTag
            }

module.exports = TagsControl
