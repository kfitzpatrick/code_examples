jQuery.fn.fieldList = function () {
  return this.each(function(){

    var fieldList = $('<div class="fieldList"></div>');
    var input = $(this);
    var ul = $('<ul class="fieldList"></ul>');
    var addButton = $("<a href='#' class='addItem'>Add</a>");
    var newItemField = $("<input type='text' class='newItemField' />");

    var addItemsToList = function(listItemLabels) {
      $(listItemLabels.split(/\s*,\s*/)).each(function() {
        if($.trim(this)) {
          var li = $('<li><span>' + this + '</span> </li>');
          var a = $('<a href="#" class="removeItem">Remove</a>').click(function () {
            li.remove();
            serializeList();
            return false;
          });
          li.append(a);
          ul.append(li);
        }
      });
    };
    
    var processNewItems = function() {
      addItemsToList(newItemField.val());
      newItemField.val('');
      serializeList();
      newItemField.focus();
    };

    var serializeList = function() {
      var newItems = ul.find('li span').map(function() {
        return $(this).text();
      }).get();
      input.val(newItems.join(', '));
    };

    input.hide();

    input.after(fieldList);
    fieldList.append(newItemField);
    fieldList.append(addButton);
    fieldList.append(ul);

    addButton.click(function() {
      processNewItems();
      return false;
    });
    
    newItemField.keydown(function(e) {
      if(e.keyCode === 13) {
        processNewItems();
        return false;
      }
    });

    addItemsToList(input.val());
  });
};

var FieldList = function() {
  $("input.field-list").fieldList();
};
