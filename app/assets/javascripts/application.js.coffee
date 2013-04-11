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
    @values = @collectValues()

  parents: ->
    # 

  collectValues: ->
    values = []
    count = 0
    for key, value of @object
      if $.type(value) != "object" && $.type(value) != "array"
        values.push
          label: key
          value: value
          count: count++
    values

$ ->
  window.base =
    start:
      luckyNumber: 7
      friend:
        name: "Simon"
        age: 22

      activities: "Skiiing Baking Running Programming Debugging Eating".split(" ")

  svg = d3.select("body").append("svg")
    .attr
      width: 1000
      height: 800
    .style("background-color", "#eef")

  maxItems   = 10
  itemsCount = 0

  buildTree = (base, wrappers=[])->
    for key, value of base
      return wrappers if wrappers.length >= maxItems
      if $.type(value) == "object" || $.type(value) == "array"
        wrappers.push new Wrapper(value)

        buildTree(value, wrappers)
    wrappers

  drawObject = (base)->
    wrappers = buildTree base

    wrapperGroupsAppend = svg.selectAll("g").data(wrappers)
      .enter()
      .append("g")
        .attr
          transform: (d) -> "translate(#{[Math.random()*900, Math.random()*600].join(' ')})"

    wrapperGroupsAppend.append("rect")
      .attr
        width: 140
        height: 200
        rx: 10
        ry: 10

    wrapperGroupsAppend.append("text")
      .text((d)-> d.label)
      .attr
        x: 10
        y: 20

    wrapperGroupsAppend.selectAll("text.value").data((d)-> d.values)
      .enter().append("text")
        .text((d)-> JSON.stringify d.value)
        .attr
          class: "value"
          x: 60
          y: (d)-> 50 + d.count * 15

    wrapperGroupsAppend.selectAll("text.label").data((d)-> d.values)
      .enter().append("text")
        .text((d)-> d.label)
        .attr
          class: "label"
          x: 10
          y: (d)-> 50 + d.count * 15


    wrapperGroups = svg.selectAll("g").data(wrappers)

    wrapperGroups.selectAll("text.value").data((d)-> d.values)
      .enter().append("text")
        .text((d)-> JSON.stringify d.value)
        .attr
          class: "value"
          x: 60
          y: (d)-> 50 + d.count * 15

    wrapperGroups.selectAll("text.label").data((d)-> d.values)
      .enter().append("text")
        .text((d)-> d.label)
        .attr
          class: "label"
          x: 10
          y: (d)-> 50 + d.count * 15

  nextFrame = ->
    drawObject base
    # clearInterval id

  id = setInterval nextFrame, 300
