React = require 'react'

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

  updateTagsList: () ->
    if @props.getAllTags?
      allTags = @props.getAllTags()
      @setState allTags

  componentDidMount: ->
    @updateTagsList()

  componentWillUnmount: ->

  componentWillReceiveProps: (nextProps) ->
    @updateTagsList()

  preventDefault: (event) ->
    event.preventDefault()
    event.stopPropagation()

  onClickOutside: (event) ->
    console.log 'outside click ?', dataAttrName
    if event.target.dataset[dataAttrName]?.indexOf(@.getDOMNode().dataset[dataAttrName]) isnt 0
      # target is not a child of the component
      console.log 'outside click !!!'
      @onPopupClose()

  onKeyDown: (event) ->
    if event.keyCode is 27 and not event.target.tagName.match /input/i
      @onPopupClose()

  onPopupOpen: ->
    @setState isPopupVisible: true, =>
      console.log 'on popup open'
      @updateTagsList()
      document.addEventListener 'keydown', @onKeyDown
      document.addEventListener 'click', @onClickOutside

  onPopupClose: ->
    @setState isPopupVisible: false, =>
      console.log 'on popup close'
      document.removeEventListener 'keydown', @onKeyDown
      document.removeEventListener 'click', @onClickOutside
      @props.onPopupClose()

  onSaveTag: (tag) ->
    @props.onSaveTag tag
    .then =>
      @updateTagsList()
      @props.onAssignTag @props.todoId, tag.id

  render: ->
    span {
        style: Styles.get 'dummy', {
          visibility: 'hidden'
          marginLeft: 4
        }, @props.styles
        className: 'pill blank has_balloon exclusively_expanded'
        'data-behavior': @props.dataBehavior
        'data-hovercontent-strategy': 'visibility'
        # onMouseEnter: @preventDefault
        # onMouseLeave: @preventDefault
        # onMouseOver: @preventDefault
        # onMouseOut: @preventDefault
        # onMouseMove: @preventDefault
      },
        a {
          href: '#'
          'data-behavior': 'expand_on_click'
          onClick: @onPopupOpen
        },
          span {}, 'Tags'

        BasecampPopup {
          header: 'Assign tags on this to-do'
          content: TagsList { tagsList: @state.tagsList, tagsIndex: @state.tagsIndex }
          footer: TagEditor { onSaveTag: @onSaveTag }
        }

module.exports = TagsButton
