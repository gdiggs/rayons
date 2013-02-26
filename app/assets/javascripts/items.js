$(function() {
  // display a message and fade in the message banner
  var showMessage = function(message) {
    $('.message:first').html(message).fadeIn(400).delay(4000).fadeOut(400);
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

  // Delete an item using ajax, then show the message and fade out the row.
  $('a.delete').on('click', function() {
    if(confirm("Are you sure you want to delete this item?")) {
      var $link = $(this);

      $.ajax({
        url: $link.attr('href'),
        type: 'DELETE',
        dataType: 'json',
        success: function(response) {
          showMessage("Item deleted!");
          $link.parents('tr').remove();
        }
      });
    }

    return false;
  });

  $('.toggle-controls a').on('click', function() {
    if($('#editing-bar').is(':visible')) {
      $('#editing-bar').fadeOut(400);
      $(this).text('show controls');
    } else {
      $('#editing-bar').fadeIn(400);
      $(this).text('hide controls');
    }
    return false;
  });

  // select random data row, highlight it and scroll the window
  // to it
  $('a.random').on('click', function() {
    $('tr.hover').removeClass('hover');
    var rows = $('tr[data-id]:not(.edit)'),
        index = Math.floor(Math.random() * rows.length),
        $row = $(rows[index]);

    $row.addClass('hover');
    $('html, body').animate( {
      scrollTop: $row.offset().top
    }, 800);

    return false;
  });
  
});
