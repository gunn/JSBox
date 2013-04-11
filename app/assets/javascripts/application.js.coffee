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

  window.objects = []

  buildTree = (base)->
    for key, value of base
      return if itemsCount++ >= maxItems
      if $.type(value) == "object" || $.type(value) == "array"
        objects.push
          key: key
          value: value
          id: itemsCount

        buildTree(value)

  drawObject = (base)->
    buildTree base

    addGroups = svg.selectAll("g").data(objects)
      .enter()
      .append("g")
        .attr
          transform: (d) -> "translate(#{[Math.random()*900, Math.random()*600].join(' ')})"

    addGroups.append("rect")
      .attr
        width: 140
        height: 200
        rx: 10
        ry: 10

    addGroups.append("text")
      .text((d)-> d.key)
      .attr
        x: 10
        y: 20

  nextFrame = ->
    drawObject base
    clearInterval id

  id = setInterval nextFrame, 300