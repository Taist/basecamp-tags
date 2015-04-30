React = require 'react'
extend = require 'react/lib/Object.assign'

{ span, a, div } = React.DOM

Styles = require './styles'
BasecampPopup = require './popup'
TagsList = require './tagsList'
TagEditor = require './tagEditor'

attrName = require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME
dataAttrName = attrName.replace(/^data-/, '').replace /-./g, (a) -> a.slice(1).toUpperCase()

TagsButton = React.createFactory React.createClass
  getInitialState: ->
    tagsList: []
    tagsIndex: {}
    isPopupVisible: false
    activeTags: null

  updateTagsList: () ->
    if @props.getAllTags?
      allTags = @props.getAllTags()
      @setState extend {}, allTags, activeTags: @props.activeTags

  componentDidMount: ->
    @updateTagsList()

    target = @refs.tagsButton.getDOMNode()

    mutationObserver = new MutationObserver (mutations) =>
      if target.style.visibility is 'hidden'
        if target.parentNode.parentNode.querySelector ':not(.taist) .expanded'
          target.style.visibility = 'visible'
          target.className += ' showing'

    mutationObserver.observe target, { attributes: true }

  componentWillReceiveProps: (nextProps) ->
    @updateTagsList()

  preventDefault: (event) ->
    event.preventDefault()
    event.stopPropagation()

  onClickOutside: (event) ->
    if event.target.dataset[dataAttrName]?.indexOf(@.getDOMNode().dataset[dataAttrName]) isnt 0
      # target is not a child of the component
      @onPopupClose()

  onKeyDown: (event) ->
    if event.keyCode is 27 and not event.target.tagName.match /input/i
      @onPopupClose()

  onPopupOpen: ->
    @setState isPopupVisible: true, =>
      @updateTagsList()
      document.addEventListener 'keydown', @onKeyDown
      document.addEventListener 'click', @onClickOutside

  onPopupClose: ->
    @setState isPopupVisible: false, =>
      document.removeEventListener 'keydown', @onKeyDown
      document.removeEventListener 'click', @onClickOutside
      @props.onPopupClose()

  onSaveTag: (tag) ->
    @props.onSaveTag tag
    .then =>
      @updateTagsList()
      @props.onAssignTag @props.todoId, tag.id
    .then (tagsList) =>
      @setState activeTags: tagsList

  onClickByTag: (tagId, isActiveNow) ->
    if isActiveNow
      console.log tagId, isActiveNow
    else
      @props.onAssignTag @props.todoId, tagId
      .then (tagsList) =>
        @setState activeTags: tagsList

  render: ->

    span {
      ref: 'tagsButton'
      style: Styles.get 'dummy', {
        visibility: 'hidden'
        marginLeft: 0
      }, @props.styles
      className: @props.classes + ' has_balloon exclusively_expanded'
      'data-behavior': @props.dataBehavior
      'data-hovercontent-strategy': 'visibility'
    },
      a {
        href: '#'
        'data-behavior': 'expand_on_click'
        onClick: @onPopupOpen
      },
        @props.content

      BasecampPopup {
        header: 'Assign tags to this to-do'
        content: TagsList {
          tagsList: @state.tagsList
          tagsIndex: @state.tagsIndex
          activeTags: @state.activeTags
          onClick: @onClickByTag
        }
        footer: TagEditor { onSaveTag: @onSaveTag }
      }

module.exports = TagsButton
