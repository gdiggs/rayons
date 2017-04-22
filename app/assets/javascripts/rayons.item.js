Rayons = Rayons || {};

Rayons.Item = {
  bind: function() {
    $(document).delegate('a.item-delete', 'click', Rayons.Item.destroy);
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
  }
};
