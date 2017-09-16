Rayons = Rayons || {};

Rayons.UI = {
  bind: function() {
    $(document).delegate('form.ajax', 'submit', Rayons.UI.ajax_submit);
    $('a.login, a.import').on('click', Rayons.UI.show_editing_form);
    $('a[data-sort]').click(Rayons.UI.sort);
  },

  // bind to form submission (adding/updating an item)
  // show the message and add the row to the top of the table
  ajax_submit: function(e) {
    var $form = $(e.target);

    $.ajax({
      url: $form.attr('action'),
      type: $form.attr('method'),
      data: $form.serialize(),
      dataType: 'json',
      success: function(item) {
        Rayons.UI.show_message("Item created!");
        $form.find('input[type=text]').val('');
      },
      error: function(response) {
        var json = JSON.parse(response.responseText);
        Rayons.UI.show_message(json.join('! '));
      }
    });

    return false;
  },

  show_editing_form: function(e) {
    $(e.target).siblings("form").show();
    $(e.target).hide();
    return false;
  },

  show_message: function(message) {
    $('.message:first').html(message).fadeIn(400).delay(4000).fadeOut(400);
  },

  sort: function(e) {
    var $this = $(e.target),
        direction = $('table').data('direction'),
        current_sort = $('table').data('sort');

    // swap direction if we're using the same sorting column
    if($this.data('sort') === current_sort) {
      if(direction === 'ASC') {
        direction = 'DESC';
      } else {
        direction = 'ASC';
      }
    } else {
      direction = 'ASC';
    }

    var new_url = $.query.set("direction", direction).set("sort", $this.data('sort')).set("search", window.filter_options.search || '').toString();
    window.location = new_url;
    return false;
  }
};
