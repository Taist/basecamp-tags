React = require 'react'
extend = require 'react/lib/Object.assign'

{ div, a, input, button, span } = React.DOM

ColorPicker = require './colorPicker'

TagEditor = React.createFactory React.createClass
  getInitialState: ->
    editedTag: null
    selectedColor: null
    isEditorActive: false
    wasEdited: false

  onActivateEditor: ->
    @setState isEditorActive: true
    @props.onSaveTag? {}

  onKeyDown: (event) ->
    action = null

    @setState wasEdited: true

    switch event.keyCode
      when 13 then action = @onSave
      when 27 then action = @onCancel

    if action
      event.preventDefault()
      event.stopPropagation()
      action()

  onSave: ->
    id = @state.editedTag?.id
    color = @state.selectedColor ? @state.editedTag?.color
    name = @refs.tagName.getDOMNode().value
    @props.onSaveTag? { id, name, color }
    @setState isEditorActive: false, selectedColor: null, wasEdited: false

  onCancel: ->
    @setState isEditorActive: false, selectedColor: null, wasEdited: false
    @props.onSaveTag? null

  onSelectColor: (color) ->
    @setState selectedColor: color

  componentWillReceiveProps: (nextProps) ->
    if nextProps.editedTag
      @setState { editedTag: nextProps.editedTag, isEditorActive: true }, =>
        if nextProps.editedTag.name? and not @state.wasEdited
          @refs.tagName?.getDOMNode().value = nextProps.editedTag.name
    else
      @setState { editedTag: null, isEditorActive: false, wasEdited: false }, =>
        @refs.tagName?.getDOMNode().value = ''

  render: ->
    actionProps =
      href: 'javascript:void(0)'
      className: 'decorated'
      style:
        lineHeight: '22px'
        marginLeft: 4

    if @state.isEditorActive
      div {},
        input {
          onKeyDown: @onKeyDown
          placeholder: 'Tag name'
          ref: 'tagName'
          type: 'text'
          style:
            width: 80
        }
        a extend({}, actionProps, onClick: @onSave), 'OK'
        a extend({}, actionProps, onClick: @onCancel), 'Cancel'
        ColorPicker {
          activeColor: @state.selectedColor ? @state.editedTag?.color
          onSelectColor: @onSelectColor
        }
    else
      a {
        href: 'javascript:void(0)'
        className: 'decorated'
        onClick: @onActivateEditor
      }, 'Add new tag'

module.exports = TagEditor
