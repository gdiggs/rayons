Rayons = {};

Rayons.Item = {
  bind: function() {
    $(document).delegate('a.delete', 'click', Rayons.Item.destroy)
               .delegate('a.edit', 'click', Rayons.Item.edit)
               .delegate('a.save', 'click', Rayons.Item.save);
    Rayons.Item.getItems();
  },

  // Delete an item using ajax, then show the message and fade out the row.
  destroy: function(e) {
    if(confirm("Are you sure you want to delete this item?")) {
      var $link = $(e.target);

      $.ajax({
        url: $link.attr('href'),
        type: 'DELETE',
        data: {
          'authenticity_token': $('[name=authenticity_token]').val()
        },
        dataType: 'json',
        success: function(response) {
          Rayons.UI.show_message("Item deleted!");
          $link.parents('tr').remove();
        }
      });
    }

    return false;
  },

  edit: function(e) {
    var $this = $(e.target),
        $row = $this.parents('tr');

    $row.find('td:not(.edit):not(.save)').each(function() {
      var text = $(this).find('a').length > 0 ? $(this).find('a').attr('href') : $(this).html().replace(/'/, '&apos;');

      $(this).html("<input type=text name="+$(this).attr('class')+" value='" + $.trim(text) + "' />");
    });

    $this.parent().hide().siblings('td.save').show();

    $('html, body').animate( {
      scrollTop: $row.offset().top - 50
    }, 100);

    return false;
  },

  getItems: function() {
    $('.js-items').fadeOut();
    $('.js-loader').fadeIn();
    $.getJSON('/items.json', window.filter_options, function(response) {
      var first = response.offset_value + 1,
          last = response.offset_value + response.limit_value,
          markup = _.map(response.items, function(item) { return Rayons.Item.render(item); });

      $('.js-loader').fadeOut(200, function() {
        $('.js-items-page-info').text(first + ' - ' + last + ' of ' + response.total_count + ' items');
        $('.js-items').html(markup).fadeIn(200);
        $('.js-pagination').html(response.pagination);
      });
    });

  },

  render: function(item) {
    var template = $('#item_template').html();
    if(item.notes && item.notes.length > 50) {
      item.notes = item.notes.substring(0, 50) + '...';
    }
    return Mustache.render(template, item);
  },

  save: function(e) {
    var data = {'authenticity_token': $('[name=authenticity_token]').val(), 'item': {}},
        $link = $(e.target);

    $link.parents('tr').find('input').each(function() { data.item[$(this).attr('name')] = $(this).val(); });

    $.ajax({
      url: $link.attr('href'),
      data: data,
      dataType: 'json',
      type: 'PUT',
      success: function(response) {
        $link.parents('tr').find('td:not(.edit):not(.save)').each(function() {
          var val = $(this).find('input').val();
          if($(this).is('.discogs_url')) {
            val = "<a href='"+val+"' target='_blank'>link</a>";
          }
          $(this).html(val);
        });
        $link.parent().hide().siblings('td.edit').show();
      }
    });
    return false;
  }
};

Rayons.Stats = {
  bind: function() {
    $.each($('.frequency'), function(i, freq) {
      $.getJSON('/stats/words_for_field?field='+$(freq).data('field'), function(response) {
        $(freq).jQCloud(response);
      });
    });

    $('.switcher a').click(Rayons.Stats.switch_view);

    if(window.location.hash === '#Words') {
      $('a[data-target=".texts"]').click();
    }

    var cal = new CalHeatMap();
    cal.init({
      start: new Date(2012, 1, 1), // February 1, 2012
      cellSize: 10,
      range: 36,
      domain: "month",
      subDomain: "day",
      legend: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      legendColors: {
        min: "#efefef",
        max: "#2c6079"
      },
      displayLegend: false,
      data: '/stats/counts_by_day.json'
    });
  },

  switch_view: function(e) {
    var $this = $(e.target);

    if($this.data('target') === undefined) { return true; }
    if($this.is('.active')) { return false; }

    $('.switcher a.active').each(function() {
      $($(this).data('target')).fadeOut(600);
      $(this).removeClass('active');
    });

    $($this.data('target')).fadeIn(600);
    $this.addClass('active');

    window.location.hash = $this.text();

    return false;
  }

};

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
