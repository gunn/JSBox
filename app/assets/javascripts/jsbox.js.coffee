window.JSBox =
  wrappers: new Dict()
  maxItems: 10
  usedObjects: []

  base:
    start:
      n: 8
      friend:
        name: "Simon"
        age: 22

      activities: "Skiiing Baking Running Programming Debugging Eating".split(" ")

  init: ->
    @stage = d3.select("body").append("div.stage")
    @svg = @stage.append("svg").attr
      width: $(@stage[0]).width()
      height: $(@stage[0]).height()-10

  addLines: (selector)->
    lines = selector.select("tbody.attrs").selectAll("tr.line").data(((d)-> d.values()), (d)-> [d.label, d.value])

    linesAppend = lines.enter().append("tr.line")

    linesAppend.append("td.label")
    linesAppend.append("td.value")

    lines.selectAll("td.label")
      .text((d)-> d.label)

    lines.selectAll("td.value")
      .text((d)-> JSON.stringify d.value )

    lines.exit().remove()

    # Associations
    lines = selector.select("tbody.assocs").selectAll("tr.line").data(((d)-> d.associations()), (d)-> [d.label, d.value])

    linesAppend = lines.enter().append("tr.line")

    linesAppend.append("td.label")
    linesAppend.append("td.value")

    lines.selectAll("td.label")
      .text((d)-> d.label)

    lines.selectAll("td.value")
      .text((d)-> $.type d.wrapper.object )

    lines.exit().remove()

    selector.select("tbody.assocs")
      .style display: (d)->
        d.values().length && d.associations().length && "table-row-group" || "none"

  buildWrappersTree: (base)->
    for key, object of base
      return if JSBox.wrappers.values.length >= JSBox.maxItems
      if $.type(object) == "object" || $.type(object) == "array"
        if !JSBox.wrappers.has(object)
          JSBox.wrappers.set object, new Wrapper(object)

        JSBox.usedObjects.push(object)
        @buildWrappersTree(object)

  draw: (base)->
    JSBox.usedObjects = []
    @buildWrappersTree {"This is the start!": base}

    for i in [(JSBox.wrappers.keys.length-1)..0]
      object = JSBox.wrappers.keys[i]
      if JSBox.usedObjects.indexOf(object) == -1
        JSBox.wrappers.delete object


    wraps = @stage.selectAll("table.wrapper:not(.exiting)").data(JSBox.wrappers.values, (d)-> d.id)

    wrapsAppend = wraps.enter()
      .append("table.wrapper")
        .style
          left: -> Math.random()*900+"px"
          top:  -> Math.random()*600+"px"

    header = wrapsAppend.append("thead").append("tr.title").append("th")
    header.attr("colspan", 2)
    header.append("h3")
      .text((d)-> d.label)

    wrapsAppend
      .style("opacity", 0)
      .transition()
        .duration(150)
        .style("opacity", 1)


    wrapsAppend.append("tbody.attrs")
    # wrapsAppend.append("tbody.assocs")

    wrapsAppend.append("tbody.assocs").append("tr").append("td.break")
      .attr colspan: 2

    wraps.call(@addLines)

    wraps.exit()
      .attr("class", "exiting")
      .transition()
        .duration(150)
        .style("opacity", 0)
      .remove()