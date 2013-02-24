$(function() {
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
});
