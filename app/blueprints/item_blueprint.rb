class ItemBlueprint < Blueprinter::Base
  identifier :id

  fields(
    :title,
    :artist,
    :year,
    :label,
    :format,
    :color,
    :condition,
    :discogs_url,
    :created_at,
  )

  association :tracks, blueprint: TrackBlueprint
end
