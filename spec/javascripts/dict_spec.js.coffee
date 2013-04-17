#= require dict
d = null

describe "Dict", ->
  beforeEach ->
    d = new Dict

  describe "set", ->
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

    it "overwrites if there is a clash", ->
      d.set 6, 1
      d.set 6, 2
      d.set true, 1
      d.set true, 2

      expect(d.get(6)   ).toEqual 2
      expect(d.get(true)).toEqual 2

    it "returns the value", ->
      array = [1, 2, 3]

      expect(d.set(5, array)).toEqual array
      expect(d.set(true,  7)).toEqual 7

  describe "set", ->
    it "returns undefined if item does not exist", ->
      expect(d.get("key")).toEqual undefined

  describe "has", ->
    it "returns true if the item exists", ->
      d.set "key", null

      expect(d.has("key")).toEqual true

    it "returns false if the item does not exist", ->
      expect(d.has("key")).toEqual false

  describe "delete", ->
    it "removes the item", ->
      d.set    "key", 55
      d.delete "key"

      expect(d.has("key")).toEqual false

    it "returns the value", ->
      d.set    "key", 55

      expect(d.delete "key").toEqual 55
