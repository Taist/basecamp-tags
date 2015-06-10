React = require 'react'
extend = require 'react/lib/Object.assign'

{ span, a, div } = React.DOM

Styles = require './styles'
BasecampPopup = require './popup'
TagsList = require './tagsList'
TagEditor = require './tagEditor'

attrName = require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME
dataAttrName = attrName.replace(/^data-/, '').replace /-./g, (a) -> a.slice(1).toUpperCase()

tagsListComponent = require './tagsList'

TagsButton = React.createFactory React.createClass
  getInitialState: ->
    tagsList: []
    tagsIndex: {}
    isPopupVisible: false
    isHovered: true
    activeTags: null
    editedTag: null

  updateTagsList: (newProps = @props) ->
    if newProps.getAllTags?
      allTags = newProps.getAllTags()
      @setState extend {}, allTags, activeTags: (newProps.activeTags or [])

  componentDidMount: ->
    @updateTagsList()

    target = @refs.tagsButton.getDOMNode()
    .parentNode.parentNode.parentNode.parentNode
    .querySelector ".nubbin"

    if target
      @setState isHovered: false

      mutationObserver = new MutationObserver (mutations) =>
        if target.style.display is 'none'
          @setState isHovered: false
        else
          @setState isHovered: true

    #   if target.style.visibility is 'hidden'
    #     if target.parentNode.parentNode.querySelector ':not(.taist) .expanded'
    #       target.style.visibility = 'visible'
    #       target.className += ' showing'
    #
      mutationObserver.observe target, { attributes: true }

  componentWillReceiveProps: (nextProps) ->
    @updateTagsList(nextProps)

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
    @setState { isPopupVisible: true, editedTag: null }, =>
      @updateTagsList()
      document.addEventListener 'keydown', @onKeyDown
      document.addEventListener 'click', @onClickOutside

  onPopupClose: ->
    @setState isPopupVisible: false, =>
      document.removeEventListener 'keydown', @onKeyDown
      document.removeEventListener 'click', @onClickOutside
      @props.onPopupClose()

  onSaveTag: (tag) ->
    shouldBeAssigned = not tag.id?
    @props.onSaveTag tag
    .then =>
      @setState { editedTag: null }, =>
        if shouldBeAssigned
          @updateTagsList()
          @props.onAssignTag @props.todoId, tag.id
          .then (tagsList) =>
            @setState activeTags: tagsList
        else
          activeTags = @state.activeTags
          @updateTagsList()
          @setState activeTags: activeTags

  onClickByTag: (tagId, isActiveNow) ->
    activeTags = @state.activeTags.map (t) -> t

    if isActiveNow
      method = 'onDeleteTag'
      activeTags = activeTags.filter (id) -> id isnt tagId
    else
      method = 'onAssignTag'
      activeTags.push tagId

    @setState { activeTags }, ->
      @props[method] @props.todoId, tagId
      .then (tagsList) =>
        @setState activeTags: tagsList

  onTagEdit: (tag) ->
    @setState editedTag: tag

  render: ->
    span {
      ref: 'tagsButton'

      style: Styles.get 'dummy', {
        marginLeft: 0
        position: 'relative'
      }, @props.styles, {
        display:
          if (@state.activeTags?.length > 0 or @state.isHovered or @state.isPopupVisible)
            'inline-block'
          else
            'none'
      }

      className: 'has_balloon exclusively_expanded' +
        unless @state.activeTags?.length > 0 then ' pill blank' else ''
      'data-behavior': @props.dataBehavior
    },
      a {
        onClick: @onPopupOpen
      },
        unless @state.activeTags?.length > 0
          span { style: cursor: 'pointer' }, 'Tags'
        else
          tagsListComponent { tagsList: @state.activeTags, tagsIndex: @state.tagsIndex }

      if @state.isPopupVisible
        BasecampPopup {
          header: 'Assign tags to this to-do'
          content: TagsList {
            tagsList: @state.tagsList
            tagsIndex: @state.tagsIndex
            activeTags: @state.activeTags
            onClick: @onClickByTag
            onTagEdit: @onTagEdit
          }
          footer: TagEditor { onSaveTag: @onSaveTag, editedTag: @state.editedTag }
        }

module.exports = TagsButton
