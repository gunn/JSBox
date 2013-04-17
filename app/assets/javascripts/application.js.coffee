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

  svg = d3.select("body").append("svg")
    .attr
      width: 1000
      height: 800
    .style("background-color", "#eef")

  addLines = (selector)->
    lines = selector.selectAll("g.line").data(((d)-> d.values()), (d)-> [d.key, d.value, d.count])

    linesAppend = lines.enter().append("g.line")

    linesAppend.append("text.label")
    linesAppend.append("text.value")

    lines.selectAll("text.label")
      .text((d)-> d.label)
      .attr
        x: 10
        y: (d)-> 50 + d.count * 15

    lines.selectAll("text.value")
      .text((d)-> JSON.stringify d.value )
      .attr
        x: 60
        y: (d)-> 50 + d.count * 15

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


    wraps = svg.selectAll("g.wrapper").data(JSBox.wrappers.values, (d)-> d.id)

    wrapsAppend = wraps.enter()
      .append("g.wrapper")
        .attr
          transform: (d)-> "translate(#{[Math.random()*900, Math.random()*600].join(' ')})"

    wrapsAppend.append("rect")
      .attr
        width: 140
        height: 200
        rx: 10
        ry: 10

    wrapsAppend.append("text")
      .text((d)-> d.label)
      .attr
        x: 10
        y: 20

    wrapsAppend.append("g.values")

    wraps.call(addLines)

    wraps.exit().remove()

  setInterval ->
    drawObject JSBox.base
  , 300
