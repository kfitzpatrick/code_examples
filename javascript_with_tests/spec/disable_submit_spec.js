require("spec_helper.js");

Screw.Unit(function(){
  describe("disableSubmit", function(){
    before(function(){
      this.div = $('<div id="test"></div>');
      this.button = $('<input type="submit" value="Submit Form"/>');
      this.form = $('<form action="javascript:void(0)"></form>').append(this.button);
      this.div.append(this.form);
      $('body').append(this.div);
      $(this.form).disableSubmit();
    });

    after(function(){
      this.div.remove();
    });

    it("should add a fake button", function(){
      expect('input:disabled[type=button][value="Sending…"]').to(be_on_page);
    });

    it("should disable the button", function(){
      expect(this.button.attr('disabled')).to(equal, true);
    });

    it("should hide the button", function(){
      expect(this.button).to(be_hidden);
    });

    it("should display a spinner while submitting", function(){
      expect('img.spinner').to(be_on_page);
    });
  });
  
  describe("enableSubmit", function(){
    before(function(){
      this.div = $('<div id="test"></div>');
      this.button = $('<input type="submit" value="Submit Form"/>');
      this.form = $('<form action="javascript:void(0)"></form>').append(this.button);
      this.div.append(this.form);
      $('body').append(this.div);
      $(this.form).disableSubmit();
      $(this.form).enableSubmit();
    });

    after(function(){
      this.div.remove();
    });

    it("should remove the fake button", function(){
      expect('input:disabled[type=button][value="Sending…"]').to_not(be_on_page);
    });

    it("should disable the button", function(){
      expect(this.button.attr('disabled')).to(equal, false);
    });

    it("should show the button", function(){
      expect(this.button).to_not(be_hidden);
    });

    it("should remove the spinner", function(){
      expect('img.spinner').to_not(be_on_page);
    });
  });
});
