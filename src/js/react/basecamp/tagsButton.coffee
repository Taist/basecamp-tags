React = require 'react'

{ span, a, div } = React.DOM

Styles = require './styles'
BasecampPopup = require './popup'
TagsList = require './tagsList'
TagEditor = require './tagEditor'


TagsButton = React.createFactory React.createClass
  getInitialState: ->
    tagsList: []

  updateTagsList: ->
    @setState tagsList: @props.getAllTags()

  componentWillReceiveProps: (nextProps) ->
    @updateTagsList()

  componentDidMount: ->
    @updateTagsList()

  preventDefault: (event) ->
    event.preventDefault()
    event.stopPropagation()

  onPopupOpen: ->
    @updateTagsList()

  onSaveTag: (tag) ->
    @props.onSaveTag(tag)
    @updateTagsList()

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
          content: TagsList { tagsList: @state.tagsList }
          footer: TagEditor { onSaveTag: @onSaveTag }
        }

module.exports = TagsButton
