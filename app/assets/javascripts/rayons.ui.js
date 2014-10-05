Rayons = Rayons || {};

Rayons.UI = {
  bind: function() {
    $(document).delegate('form.ajax', 'submit', Rayons.UI.ajax_submit);
    $('a.login, a.import').on('click', Rayons.UI.show_editing_form);
    $('a.random').on('click', Rayons.UI.scroll_to_random);
    $('a[data-sort]').click(Rayons.UI.sort);
    $('.js-search').submit(Rayons.UI.search);
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
        console.log("RESP", item);
        Rayons.UI.show_message("Item created!");
        var markup = Rayons.Item.render(item);

        $(markup).insertAfter('table tr:first');
        $form.find('input[type=text]').val('');
      },
      error: function(response) {
        var json = JSON.parse(response.responseText);
        Rayons.UI.show_message(json.join('! '));
      }
    });

    return false;
  },

  // select random data row, highlight it and scroll the window
  // to it
  scroll_to_random: function() {
    $('tr.hover').removeClass('hover');
    var rows = $('tr[data-id]:not(.edit)'),
        index = Math.floor(Math.random() * rows.length),
        $row = $(rows[index]);

    $row.addClass('hover');
    $('html, body').animate( {
      scrollTop: $row.offset().top
    }, {duration: 1200, easing: "easeInQuad"});

    return false;
  },

  search: function(e) {
    var $form = $(e.target),
        search_term = $form.find('input').val();

    window.history.pushState({}, '', window.location.origin+'?search='+search_term);
    window.filter_options = {
      search: search_term
    };
    Rayons.Item.getItems();

    return false;
  },

  show_editing_form: function(e) {
    $('header form').show();
    $(e.target).hide();
    return false;
  },

  show_message: function(message) {
    $('.message:first').html(message).fadeIn(400).delay(4000).fadeOut(400);
  },

  sort: function(e) {
    var $this = $(e.target),
        direction = $('table').data('direction'),
        current_sort = $('table').data('sort'),
        delim = window.location.href.indexOf('?') == -1 ? '?' : '&';

    // swap direction if we're using the same sorting column
    if($this.data('sort') == current_sort) {
      if(direction == 'ASC') {
        direction = 'DESC';
      } else {
        direction = 'ASC';
      }
    } else {
      direction = 'ASC';
    }

    var new_url = $.query.set("direction", direction).set("sort", $this.data('sort')).set("search", window.filter_options.search || '').toString();
    window.history.pushState({}, '', window.location.origin+new_url);

    $('table').data('direction', direction).data('sort', $this.data('sort'));

    window.filter_options.sort = $this.data('sort');
    window.filter_options.direction = direction;
    Rayons.Item.getItems();
    return false;
  },
};
