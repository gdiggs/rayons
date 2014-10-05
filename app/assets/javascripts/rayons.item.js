Rayons = Rayons || {};

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
