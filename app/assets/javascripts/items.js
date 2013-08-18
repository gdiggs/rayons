$(function() {
  Rayons.UI.bind();
  if($('#items').length > 0) { Rayons.Item.bind(); }
  if($('#stats').length > 0) { Rayons.Stats.bind(); }
});

