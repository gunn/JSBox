class window.Wrapper
  constructor: (@object)->
    @label = $.type(@object)
    @id = Math.random()

  values: ->
    values = []
    for key, value of @object
      if $.type(value) != "object" && $.type(value) != "array"
        values.push
          label: key
          value: value
    values

  associations: ->
    associations = []
    for key, assoc of @object
      if $.type(assoc) == "object" || $.type(assoc) == "array"
        associations.push
          label: key
          wrapper: JSBox.wrappers.get(assoc)
    associations
