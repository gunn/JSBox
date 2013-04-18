# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require d3
#= require_tree .

class Wrapper
  constructor: (@object)->
    @label = $.type(@object)
    @id = Math.random()

  parents: ->
    # 

  values: ->
    values = []
    count = 0
    for key, value of @object
      if $.type(value) != "object" && $.type(value) != "array"
        values.push
          label: key
          value: value
          count: count++
    values

d3.selection.enter::bareAppend = d3.selection::bareAppend = d3.selection::append
d3.selection.enter::append = d3.selection::append = (selector)->
  [name, classes...] = selector.split(".")

  @bareAppend(name).attr("class", classes.join(" "))

$ ->
  window.JSBox =
    wrappers: new Dict()
    maxItems: 10
    usedObjects: []

  JSBox.base =
    start:
      n: 8
      friend:
        name: "Simon"
        age: 22

      activities: "Skiiing Baking Running Programming Debugging Eating".split(" ")

  stage = d3.select("body").append("div.stage")
    .style("background-color", "#eef")

  addLines = (selector)->
    lines = selector.selectAll("tr.line").data(((d)-> d.values()), (d)-> [d.key, d.value, d.count])

    linesAppend = lines.enter().append("tr.line")

    linesAppend.append("td.label")
    linesAppend.append("td.value")

    lines.selectAll("td.label")
      .text((d)-> d.label)

    lines.selectAll("td.value")
      .text((d)-> JSON.stringify d.value )

    lines.exit().remove()

  buildWrappersTree = (base)->
    for key, object of base
      return if JSBox.wrappers.values.length >= JSBox.maxItems
      if $.type(object) == "object" || $.type(object) == "array"
        if !JSBox.wrappers.has(object)
          JSBox.wrappers.set object, new Wrapper(object)

        JSBox.usedObjects.push(object)
        buildWrappersTree(object)

  drawObject = (base)->
    JSBox.usedObjects = []
    buildWrappersTree base

    for object in JSBox.wrappers.keys
      if JSBox.usedObjects.indexOf(object) == -1
        JSBox.wrappers.delete object


    wraps = stage.selectAll("table.wrapper:not(.exiting)").data(JSBox.wrappers.values, (d)-> d.id)

    wrapsAppend = wraps.enter()
      .append("table.wrapper")
        .attr
          transform: (d)-> "translate(#{[Math.random()*900, Math.random()*600].join(' ')})"

    wrapsAppend.append("h3")
      .text((d)-> d.label)

    wrapsAppend
      .style("opacity", 0)
      .transition()
        .duration(150)
        .style("opacity", 1)

    wraps.call(addLines)

    wraps.exit()
      .attr("class", "exiting")
      .transition()
        .duration(150)
        .style("opacity", 0)
      .remove()

  setInterval ->
    drawObject JSBox.base
  , 300
