Rayons = Rayons || {};

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
