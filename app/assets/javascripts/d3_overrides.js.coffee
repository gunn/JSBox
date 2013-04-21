d3.selection.enter::bareAppend = d3.selection::bareAppend = d3.selection::append
d3.selection.enter::append = d3.selection::append = (selector)->
  [name, className] = selector.split(".")

  s = @bareAppend(name)
  s.attr("class", className) if className
  s
