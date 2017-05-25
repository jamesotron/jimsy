require "uri"
require "nokogiri"
require "net/http"

module Jimsy
  class BusService
    # This MetLink code came from Eoin, who is very nice for sharing it with me.
    DEFAULT_STOP     = "5502".freeze
    DEFAULT_SERVICES = %w[24].freeze

    Departure = Struct.new(:service, :destination, :when, :extra)

    def initialize(stop)
      @stop = stop
    end

    # .../departures        returns 20 results
    # .../departures?more=1 returns 40 results
    # .../departures?more=2 returns 60 results
    # .../departures?more=3 returns 80 results
    # .../departures?more=4 returns 100 results
    # etc.
    def departures
      uri = URI("https://www.metlink.org.nz/stop/#{stop}/departures?more=4")
      response = Net::HTTP.get(uri)
      document = Nokogiri::HTML(response)
      document.css(".rt-info-content tr").map do |tr|
        Departure.new(*tr.css("td").map { |td| td.text.strip })
      end
    end

    private

    attr_reader :stop
  end
end
