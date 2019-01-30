class ItemAlexaPresenter
  attr_accessor :intent, :slots, :launch_request

  INTENTS = {
    formatted: "FormattedItem",
    random: "RandomItem",
    stop: "AMAZON.StopIntent",
  }.freeze
  LAUNCH_REQUEST_TYPE = "LaunchRequest".freeze

  def initialize(params)
    @launch_request = params.fetch(:request, {})[:type] == LAUNCH_REQUEST_TYPE
    @intent = params.fetch(:request, {}).fetch(:intent, {})[:name]
    @slots = params.fetch(:request, {}).fetch(:intent, {})[:slots]
  end

  def as_json(*)
    if launch_request
      launch_request_response
    else
      item_response
    end
  end

  def item
    @item ||=
      case intent
      when INTENTS[:formatted]
        format = @slots[:format][:value].gsub(/ inch/, '"')
        Item.where(format: format).order("RANDOM()").limit(1).first
      when INTENTS[:random]
        Item.offset(rand(Item.count)).first
      end
  end

  private

  def item_description
    result = "<speak>"
    if intent == INTENTS[:stop]
      result << "<p>Happy listening!</p>"
    elsif item
      result << "<p>You should listen to \"<emphasis>#{item.title}</emphasis>\" by <emphasis>#{item.artist}</emphasis>"
      result << " on <emphasis>#{item.label}</emphasis>" if item.label
      result << ".</p> <p>It is a <emphasis>#{item["format"].gsub(/"/, " inch")}</emphasis> record"
      result << " released in <emphasis>#{item.year}</emphasis>" if item.year
      result << ".</p> <p>It was added to your collection on #{item.created_at.strftime("%B %-d, %Y")}.</p>"
    else
      result << "<p>Sorry, I couldn't find anything.</p>"
    end
    result << "</speak>"
    result
  end

  def launch_request_response
    {
      version: "1.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: 'Welcome to The Record Collection! You can ask me "what I should listen to" or for a specific format with "ask the record collection for a 12 inch record."'
        },
      },
    }
  end

  def item_response
    {
      version: "1.0",
      card: {
        title: "The Record Collection",
        type: "Simple",
        content: item_description,
      },
      response: {
        outputSpeech: {
          type: "SSML",
          ssml: item_description,
        },
      },
    }
  end
end
