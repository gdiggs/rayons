Rayons = Rayons || {};

Rayons.Item = {
  bind: function() {
    $(document).delegate('a.item-delete', 'click', Rayons.Item.destroy);
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
        success: function() {
          Rayons.UI.show_message("Item deleted!");
          $link.parents('tr').remove();
        }
      });
    }

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
  }
};
