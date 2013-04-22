#= require wrapper

describe "Wrapper", ->
  describe "constructor", ->
    it "takes and holds an object", ->
      obj = {a: 8}
      wrapper1 = new Wrapper(6)
      wrapper2 = new Wrapper(obj)

      expect(wrapper1.object).toEqual 6
      expect(wrapper2.object).toEqual obj

  describe "id", ->
    it "is unique", ->
      expect((new Wrapper()).id).not.toEqual (new Wrapper()).id

      ids = []
      for i in [0..100]
        id = (new Wrapper()).id
        expect(ids).not.toContain id
        ids.push id

    it "is constant when its object changes", ->
      obj = {a: 2}
      wrapper = new Wrapper(obj)
      id = wrapper.id
      obj.a = 6
      obj.b = []

      expect(wrapper.id).toEqual id

  describe "values()", ->
    it "returns an empty array when there are no values", ->
      wrapper = new Wrapper({})
      
      expect(wrapper.values().length).toEqual 0
      expect($.type(wrapper.values())).toEqual "array"

    it "returns an aray of objects describing the values", ->
      wrapper = new Wrapper({age: 25, name: "Arthur"})
      values = wrapper.values()

      expect(values[0].label).toEqual "age"
      expect(values[0].value).toEqual 25
      expect(values[1].label).toEqual "name"
      expect(values[1].value).toEqual "Arthur"

    it "collects all types of value", ->
      for value in [1, false, null, undefined, "text"]
        wrapper = new Wrapper({key: value})

        expect(wrapper.values()[0].value).toEqual value

    it "does not collect objects or arrays", ->
      wrapper = new Wrapper({obj: {}, array: []})
      expect(wrapper.values().length).toEqual 0
