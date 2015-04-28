React = require 'react'

{ div, button } = React.DOM

FreshBooksAPIEnablePage = React.createFactory React.createClass
  render: ->
    div { style: display: 'inline-block' }, 'TAG LIST'

module.exports = FreshBooksAPIEnablePage
