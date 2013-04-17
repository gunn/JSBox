#= require dict
d = null

describe "Dict", ->
  describe "set", ->
    beforeEach ->
      d = new Dict

    it "works with keys of generic types", ->
      d.set 1,         "number"
      d.set false,     "boolean"
      d.set null,      "null"
      d.set undefined, "undefined"
      d.set "text",    "string"

      expect( d.get 1         ).toEqual "number"
      expect( d.get false     ).toEqual "boolean"
      expect( d.get null      ).toEqual "null"
      expect( d.get undefined ).toEqual "undefined"
      expect( d.get "text"    ).toEqual "string"

    it "works with complex objects", ->
      emptyArray = []
      populatedArray = [1,2,3]
      emptyObject = {}
      populatedObject = {a: 1}

      d.set emptyArray,      "empty array"
      d.set populatedArray,  "populated array"
      d.set emptyObject,     "empty object"
      d.set populatedObject, "populated object"

      expect( d.get emptyArray      ).toEqual "empty array"
      expect( d.get populatedArray  ).toEqual "populated array"
      expect( d.get emptyObject     ).toEqual "empty object"
      expect( d.get populatedObject ).toEqual "populated object"
    
