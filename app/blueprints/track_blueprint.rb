class TrackBlueprint < Blueprinter::Base
  identifier :id

  fields :name,
    :artist,
    :duration,
    :number
end
