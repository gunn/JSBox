class window.Dict
  constructor: ->
    @keys = []
    @values = []

  set: (key, value)->
    @delete key
    @keys.push key
    @values.push value
    value

  get: (key)->
    @values[@keys.indexOf(key)]

  delete: (key)->
    i = @keys.indexOf(key)
    if i != -1
      @keys.splice i, 1
      @values.splice i, 1
