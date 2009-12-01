jQuery.fn.disableSubmit = function () {
  return this.each(function(){
    var submit = $(this).find(':submit');
    submit.after('<img class="spinner" src="/images/spinner.gif" />');
    submit.after('<input type="button" value="Sending…" disabled="disabled"/>');
    submit.attr('disabled', true).hide();
  });
};

jQuery.fn.enableSubmit = function () {
  return this.each(function() {
    $(this).find(":button[value='Sending…']").remove();
    $(this).find("img.spinner").remove();
    $(this).find(":submit:disabled").removeAttr("disabled").show();
  });
};

var DisableSubmit = function() {
  $('form').each(function() {
    var form = $(this);
    form.find('input[type=submit]').click(function() {
      $(form).disableSubmit();
    });
  });
};