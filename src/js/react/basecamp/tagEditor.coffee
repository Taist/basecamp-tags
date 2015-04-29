React = require 'react'
extend = require 'react/lib/Object.assign'

{ div, a, input, button, span } = React.DOM

TagEditor = React.createFactory React.createClass
  getInitialState: ->
    isEditorActive: false

  onActivateEditor: ->
    @setState isEditorActive: true

  onKeyDown: (event) ->
    switch event.key
      when 'Enter' then @onSave()
      when 'Escape' then @onCancel()

  onSave: ->
    name = @refs.tagName.getDOMNode().value
    @props.onSaveTag? { name }
    @setState isEditorActive: false

  onCancel: ->
    @setState isEditorActive: false

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
          placeholder: 'Tag name'
          ref: 'tagName'
          type: 'text'
          style:
            width: 80
        }
        a extend({}, actionProps, onClick: @onSave), 'OK'
        a extend({}, actionProps, onClick: @onCancel), 'Cancel'
    else
      a {
        href: 'javascript:void(0)'
        className: 'decorated'
        onClick: @onActivateEditor
      }, 'Add new tag'

module.exports = TagEditor
