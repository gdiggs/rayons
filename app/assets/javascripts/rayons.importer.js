Rayons = Rayons || {};

Rayons.Importer = {
  bind: function() {
    $(document).delegate('.item-form', 'submit', Rayons.Importer.formHandler);
  },

  formHandler: function(e) {
    var $form = $(e.target);

    $.ajax({
      url: $form.attr('action'),
      type: $form.attr('method'),
      data: $form.serialize(),
      success: function(data) {
        Rayons.UI.show_message("Item saved!");
        $form.slideUp(500);
      }
    });

    return false;
  }
};
