class window.JSBox
  @wrappers: new Dict()

  constructor: (@baseObject)->
    @stage = d3.select("body").append("div.stage")
    @svg = @stage.append("svg")

    @cluster = d3.layout.tree()
      .children((d)-> d.childWrappers())

    @diagonal = d3.svg.diagonal()
      .projection (d)-> [d.y, d.x]

    @duration    = 500
    @maxItems    = 10
    @usedObjects = []

    @resize()

  resize: ->
    @cluster.size [
      $(".stage").height()-200
      $(".stage").width()-180
    ]
    @draw(true)

  addLines: (lines, type, valueCallback)->
    linesAppend = lines.enter().append("tr.line")

    linesAppend.append("td.label")
    linesAppend.append("td.value")

    lines.selectAll("td.label")
      .text((d)-> d.label)

    lines.selectAll("td.value")
      .text valueCallback

    lines.exit().remove()

  addLineGroups: (selector)=>
    lines = selector.select("tbody.attrs").selectAll("tr.line")
      .data(((d)-> d.values()), (d)-> [d.label, d.value])

    lines.call @addLines, "attrs", (d)->
      if $.type(d.value)=="function"
        d.value.toString()
      else
        JSON.stringify d.value

    # Associations
    lines = selector.select("tbody.assocs").selectAll("tr.line")
      .data(((d)-> d.associations()), (d)-> [d.label, d.value])

    lines.call @addLines, "attrs", (d)-> $.type d.wrapper.object


    selector.select("tbody.assocs td.break")
      .style display: (d)->
        d.values().length && d.associations().length && "table-cell" || "none"

  buildWrappersTree: (base)->
    for key, object of base
      return if JSBox.wrappers.values.length >= @maxItems
      if $.type(object) == "object" || $.type(object) == "array"
        if !JSBox.wrappers.has(object)
          JSBox.wrappers.set object, new Wrapper(object)

        @usedObjects.push(object)
        @buildWrappersTree(object)

  draw: (instant)->
    time = if instant then 0 else @duration

    @usedObjects = []
    @buildWrappersTree {"This is the start!": @baseObject}

    for i in [(JSBox.wrappers.keys.length-1)..0]
      object = JSBox.wrappers.keys[i]
      if @usedObjects.indexOf(object) == -1
        JSBox.wrappers.delete object

    nodes = @cluster.nodes(JSBox.wrappers.get(@baseObject))

    paths = @svg.selectAll("path")
      .data(@cluster.links(nodes))
    circles = @svg.selectAll("circle")
      .data(nodes)

    paths.enter().append("path").transition().duration(time)
      .attr("d", @diagonal)
    circles.enter().append("circle")
      .attr
        r: 10
        cx: (d)->d.y
        cy: (d)->d.x
        fill: "#fA0"

    paths.transition().duration(time).attr("d", @diagonal)
    circles.transition().duration(time).attr
      cx: (d)->d.y
      cy: (d)->d.x

    paths.exit().remove()
    circles.exit().remove()

    wraps = @stage.selectAll("table.wrapper:not(.exiting)")
      .data nodes, (d)-> d.id

    wrapsAppend = wraps.enter()
      .append("table.wrapper")

    header = wrapsAppend.append("thead").append("tr.title").append("th")
    header.attr("colspan", 2)
    header.append("h3")
      .text((d)-> d.label)

    # wrapsAppend
    #   .style("opacity", 0)
    #   .transition()
    #     .duration(150)
    #     .style("opacity", 1)

    wrapsAppend.append("tbody.attrs")

    wrapsAppend.append("tbody.assocs").append("tr").append("td.break")
      .attr colspan: 2

    wraps.transition().duration(time).style
      left: (d)-> d.y+"px"
      top:  (d)-> d.x+"px"

    wraps.call(@addLineGroups)

    wraps.exit()
      .attr("class", "exiting")
      .transition()
        .duration(150)
        .style("opacity", 0)
      .remove()
