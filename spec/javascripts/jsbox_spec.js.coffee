#= require d3
#= require d3_overrides
#= require jsbox
#= require wrapper
#= require dict

main = null

describe "JSBox", ->
  describe "init", ->
    it "adds the stage", ->
      expect($(".stage").length).toEqual 0

      JSBox.init()
      expect($(".stage").length).toEqual 1

  describe "draw", ->
    beforeEach ->
      main =
        object:
          name: "Ed"
          pet:
            type: "cat"
        array: [1, 2]
        luckNumber: 7

      JSBox.draw main
    
    it "draws the tree of objects fed into it", ->
      expect($(".wrapper").length).toEqual 3
      expect($(".wrapper h3:contains('object')").length).toEqual 2
      expect($(".wrapper h3:contains('array')").length).toEqual 1

    describe "adding objects", ->
      it "updates", ->
        

      it "existing objects keep positions", ->
        
    describe "removing objects", ->
      it "updates", ->

      it "existing objects keep positions", ->

    describe "adding values", ->
      it "updates", ->
        
    describe "removing values", ->
      it "updates", ->
