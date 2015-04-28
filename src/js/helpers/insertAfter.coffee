module.exports = (newElement, targetElement) ->
  parent = targetElement.parentNode
  if parent.lastchild is targetElement
    parent.appendChild newElement
  else
    parent.insertBefore newElement, targetElement.nextSibling
