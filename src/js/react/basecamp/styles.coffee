extend = require 'react/lib/Object.assign'

namedStyles =
  tag:
    background: '#e2e9f8'
    fontSize: '12px'
    lineHeight: '16px'
    padding: '0 7px'
    border: '1px solid transparent'
    whiteSpace: 'nowrap'
    display: 'inline-block'
    borderRadius: 12
    cursor: 'pointer'

module.exports =
  get: (name, styles...) ->
    styles.unshift namedStyles[name]
    styles.unshift {}
    extend.apply null, styles
