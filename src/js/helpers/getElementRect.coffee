module.exports = (elem) ->
  rect = {}
  if elem
    top = 0
    left = 0
    width = elem.offsetWidth
    height = elem.offsetHeight
    while (elem)
      top = top + parseInt elem.offsetTop
      left = left + parseInt elem.offsetLeft
      elem = elem.offsetParent

    rect = { top, left, width, height }
  rect
