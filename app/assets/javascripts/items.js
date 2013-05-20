$(function() {
  // display a message and fade in the message banner
  var showMessage = function(message) {
    $('.message:first').html(message).fadeIn(400).delay(4000).fadeOut(400);
  };

  $('a[data-sort]').click(function() {
    var direction = $('table').data('direction'),
        current_sort = $('table').data('sort'),
        delim = window.location.href.indexOf('?') == -1 ? '?' : '&';

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

    window.location.href = window.location.href + delim + 'sort='+$(this).data('sort')+'&direction='+direction;
    return false;
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
      },
      error: function(response) {
        var json = JSON.parse(response.responseText);
        showMessage(json.join('! '));
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
        data: {
          'authenticity_token': $('[name=authenticity_token]').val()
        },
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
    }, {duration: 1200, easing: "easeInQuad"});

    return false;
  });

  $('a.edit').on('click', function() {
    var $row = $(this).parents('tr');
    $row.find('td:not(.edit):not(.save)').each(function() {
      $(this).html("<input type=text name="+$(this).attr('class')+" value='" + $(this).html().replace(/'/, '&apos;') + "' />");
    });

    $(this).parent().hide().siblings('td.save').show();

    $('html, body').animate( {
      scrollTop: $row.offset().top - 50
    }, 100);

    return false;
  });

  $('a.save').on('click', function() {
    var data = {'authenticity_token': $('[name=authenticity_token]').val(), 'item': {}},
        $link = $(this);

    $link.parents('tr').find('input').each(function() { data.item[$(this).attr('name')] = $(this).val(); });

    $.ajax({
      url: $link.attr('href'),
      data: data,
      dataType: 'json',
      type: 'PUT',
      success: function(response) {
        $link.parents('tr').find('td:not(.edit):not(.save)').each(function() {
          $(this).html($(this).find('input').val());
        });
        $link.parent().hide().siblings('td.edit').show();
      }
    });
    return false;
  });

  $('a.login, a.import').on('click', function() {
    $('#editing-bar form').show();
    $(this).hide();
    return false;
  });

  if($('.chart').length) {
    // creates a padded hex string from a given r, g, or b value
    var decimalToHex = function(i) {
      hex = i.toString(16);
      if(hex.length < 2) {
        hex = "0" + hex;
      }
      return hex;
    };

    // generates a linear gradient for a given range by splitting into rgb values
    // and then joining back into hex
    var colorGradient = function(start, finish, num_steps) {
      var steps = [],
        start_r = parseInt(start.substring(0,2), 16),
        start_g = parseInt(start.substring(2,4), 16),
        start_b = parseInt(start.substring(4,6), 16),
        finish_r = parseInt(finish.substring(0,2), 16),
        finish_g = parseInt(finish.substring(2,4), 16),
        finish_b = parseInt(finish.substring(4,6), 16),
        incr_r = (finish_r - start_r) / num_steps,
        incr_g = (finish_g - start_g) / num_steps,
        incr_b = (finish_b - start_b) / num_steps;
      for(var i=0; i<num_steps; i++) {
        steps[i] = '#' + [
          decimalToHex(Math.round((incr_r*i) + start_r)),
          decimalToHex(Math.round((incr_g*i) + start_g)),
          decimalToHex(Math.round((incr_b*i) + start_b))
        ].join('');
      };

      return steps;
    };

    $('.chart').each(function(i) {
      var $elem = $(this),
          ctx = $elem.find('canvas')[0].getContext("2d");

      $.getJSON('/stats', { field: $elem.attr('data-field') }, function(response) {
        var data = [],
            colors = colorGradient('224466', '6699bb', response.length);

        $.each(response, function(i, datum) {
          datum.color = colors[i % colors.length];
          data[i] = datum;
        });

        new Chart(ctx).Pie(data, {
          segmentStrokeColor: '#2F2F2F',
          segmentStrokeWidth: 1,
          animation: false
        });
      });
    });
  }

  $.each($('.frequency'), function(i, freq) {
    $.getJSON('/items/words_for_field?field='+$(freq).data('field'), function(response) {
      $(freq).jQCloud(response);
    });
  });
});

