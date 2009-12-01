require("spec_helper.js");
require("../../public/javascripts/field_list.js");

Screw.Unit(function(){
  describe("FieldList", function(){
    before(function(){
      this.div = $('<div id="test"></div>');
      $('body').append(this.div);
      this.input = $('<input type="text" value="foo, bar"/>');
      this.div.append(this.input);
      $(this.input).fieldList();
    });

    after(function(){
      this.div.remove();
    });
    
    describe("building the field list", function(){
      describe("with an empty initial input", function(){
        before(function(){
          this.div.empty();
          this.input = $('<input type="text" value=""/>');
          this.div.append(this.input);
          $(this.input).fieldList();
        });
        
        it("does not create an empty list item", function(){
          expect("#test ul.fieldList li").to_not(be_on_page);
        });
      });

      it("hides the default input field", function(){
        expect(this.input).to(be_hidden);
      });

      it("builds a list out of the comma seperated values in the field", function(){
        expect("#test ul.fieldList li:contains('foo')").to(be_on_page);
        expect("#test ul.fieldList li:contains('bar')").to(be_on_page);
      });

      it("build an input field and a button", function() {
        expect("#test input.newItemField:text").to(be_on_page);
        expect("#test a.addItem:contains('Add')").to(be_on_page);
      });
    
      it("adds remove links to all the list items", function(){
        expect("#test ul.fieldList li:contains('foo') a:contains('Remove')").to(be_on_page);
      });
    });
    
    describe("hitting enter", function() {
      before(function(){
        $("#test input.newItemField").val("example.com");
        keyEvent = $.Event('keydown');
        keyEvent.keyCode = 13;
        $('#test input.newItemField').trigger(keyEvent);
      });

      it("adds a new list item", function(){
        expect("#test ul.fieldList li:contains('example.com')").to(be_on_page);
      });
    });

    describe("clicking the 'Add' button", function(){
      describe("when the new item field has a string in it (with no commas)", function(){
        before(function(){
          $("#test input.newItemField").val("example.com");
          $('#test a.addItem').click();
        });

        it("clears the new item field", function(){
          expect($("#test input.newItemField").val()).to(be_blank);
        });

        it("leaves the other items", function(){
          expect("#test ul.fieldList li:contains('foo')").to(be_on_page);
          expect("#test ul.fieldList li:contains('bar')").to(be_on_page);
        });

        it("adds a new list item", function(){
          expect("#test ul.fieldList li:contains('example.com')").to(be_on_page);
        });

        it("appends to the hidden input field's value", function(){
          expect(this.input.val()).to(match, /foo/);
          expect(this.input.val()).to(match, /bar/);
          expect(this.input.val()).to(match, /example.com/);
        });

        // it("puts focus back on the input box", function(){
        //   expect('input.newItemField').to(have_focus);
        // });
      });

      describe("with comma seperate values", function(){
        before(function(){
          $("#test input.newItemField").val("abc.com, nbc.org");
          $("#test a.addItem").click();
        });

        it("adds a new list item for each value", function(){
          expect("#test ul.fieldList li:contains('abc.com')").to(be_on_page);
          expect("#test ul.fieldList li:contains('nbc.org')").to(be_on_page);
          expect("#test ul.fieldList li:contains('abc.com, nbc.org')").to_not(be_on_page);
          expect("#test ul.fieldList li:contains('foo')").to(be_on_page);
        });
      });

    });
    
    describe("clicking the remove button", function() {
      before(function(){
        $("#test ul.fieldList li:contains('foo') a.removeItem").click();
      });

      // it("does not do the default link action", function(){
      //   expect(window.location.href).to_not(match, /#$/);
      // });
      
      it("remove the associated value from the hidden input string", function(){
        expect(this.input.val()).to(match, /bar/);
        expect(this.input.val()).to_not(match, /foo/);
      });
      
      it("should remove the associated list item", function(){
        expect("#test ul.fieldList li:contains('foo')").to_not(be_on_page);
      });
    });

  });
});