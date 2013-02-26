$(function() {
  // display a message and fade in the message banner
  var showMessage = function(message) {
    $('.message:first').html(message).fadeIn(400);
  };

  $('a[data-sort]').click(function() {
    var direction = $('table').data('direction'),
        current_sort = $('table').data('sort');
    
    // swap direction if we're using the same sorting column
    if($(this).data('sort') == current_sort) {
      if(direction == 'ASC') {
        direction = 'DESC';
      } else {
        direction = 'ASC';
      }
    } else {
      direction = 'ASC';
    }

    window.location.href = '/?sort='+$(this).data('sort')+'&direction='+direction;
  });

  // bind to form submission (adding/updating an item)
  // show the message and add the row to the bottom of the table
  $('form.ajax').on('submit', function() {
    var $form = $(this);

    $.ajax({
      url: $form.attr('action'),
      type: $form.attr('method'),
      data: $form.serialize(),
      dataType: 'json',
      success: function(response) {
        console.log("RESP", response);
        showMessage("Item created!");
        $(response.item_markup).insertAfter('table tr:first');
        $form.find('input[type=text]').val('');
      }
    });

    return false;
  });
});
