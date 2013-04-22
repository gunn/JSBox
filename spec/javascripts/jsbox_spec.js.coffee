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
        friend:
          name: "Ed"
          pet:
            type: "cat"
        numbers: [1, 2]
        luckNumber: 7

      JSBox.draw main
    
    it "draws the tree of objects fed into it", ->
      expect($(".wrapper").length).toEqual 4
      expect($(".wrapper h3:contains('object')").length).toEqual 3
      expect($(".wrapper h3:contains('array')" ).length).toEqual 1

    describe "adding objects", ->
      it "updates", ->
        main.object = {}
        main.array  = []
        JSBox.draw main

        expect($(".wrapper h3:contains('object')").length).toEqual 4
        expect($(".wrapper h3:contains('array')" ).length).toEqual 2

      it "existing objects keep positions", ->
        
    describe "removing objects", ->
      it "updates", ->
        delete main.numbers
        main.friend.pet = null
        JSBox.draw main

        expect($(".wrapper h3:contains('object')").length).toEqual 2
        expect($(".wrapper h3:contains('array')" ).length).toEqual 0

      it "existing objects keep positions", ->

    describe "adding values", ->
      it "updates", ->
        main.friend.pet.age = 4
        JSBox.draw main

        tds = $(".wrapper tbody.attrs tr:last-child td")

        expect(tds[0].text()).toEqual "age"
        expect(tds[1].text()).toEqual "4"

    describe "updating values", ->
      it "updates", ->
        

    describe "removing values", ->
      it "updates", ->
        expect($(".wrapper td:contains('cat')").length).toEqual 1

        delete main.friend.pet.type
        JSBox.draw main

        expect($(".wrapper td:contains('cat')").length).toEqual 1
