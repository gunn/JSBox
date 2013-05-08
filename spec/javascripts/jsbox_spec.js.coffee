#= require jquery
#= require jquery-ui
#= require d3
#= require d3_overrides
#= require jsbox
#= require wrapper
#= require dict

main = null
jsbox = null

describe "JSBox", ->
  describe "init", ->
    it "adds the stage", ->
      expect($(".stage").length).toEqual 0

      jsbox = new JSBox({})
      expect($(".stage").length).toEqual 1

  describe "draw", ->
    beforeEach ->
      main =
        friend:
          name: "Ed"
          pet:
            type: "cat"
        numbers: [1, 2]
        luckyNumber: 7

      jsbox.show main
    
    it "draws the tree of objects fed into it", ->
      expect($(".stage").length).toEqual 1
      expect($(".wrapper").length).toEqual 4
      expect($(".wrapper h3:contains('object')").length).toEqual 3
      expect($(".wrapper h3:contains('array')" ).length).toEqual 1

    describe "adding objects", ->
      it "updates", ->
        main.object = {}
        main.array  = []
        jsbox.show main

        expect($(".wrapper h3:contains('object')").length).toEqual 4
        expect($(".wrapper h3:contains('array')" ).length).toEqual 2

      it "puts object references in tbody.assocs", ->

        expect($(".stage").length).toEqual 1
        jsbox.show obj: {}

        expect($(".wrapper tbody.assocs td:first-child").text()).toEqual "obj"
        expect($(".wrapper tbody.assocs td:last-child").text() ).toEqual "object"

      it "existing objects keep positions", ->
        
    describe "removing objects", ->
      it "updates", ->
        delete main.numbers
        main.friend.pet = null
        jsbox.show main

        expect($(".wrapper h3:contains('object')").length).toEqual 2
        expect($(".wrapper h3:contains('array')" ).length).toEqual 0

      it "existing objects keep positions", ->

    describe "adding values", ->
      it "updates", ->
        petWrapper = $(".wrapper td:contains('cat')").parents(".wrapper")

        main.friend.pet.age = 4
        jsbox.show main

        tds = petWrapper.find("tbody.attrs tr:last-child td")

        expect($(tds[0]).text()).toEqual "age"
        expect($(tds[1]).text()).toEqual "4"

      it "puts values in tbody.attrs", ->
        jsbox.show number: 6

        expect($(".wrapper tbody.attrs td:first-child").text()).toEqual "number"
        expect($(".wrapper tbody.attrs td:last-child").text() ).toEqual "6"

    describe "updating values", ->
      it "updates", ->
        

    describe "removing values", ->
      it "updates", ->
        expect($(".wrapper td:contains('cat')").length).toEqual 1

        delete main.friend.pet.type
        jsbox.show main

        expect($(".wrapper td:contains('cat')").length).toEqual 0
