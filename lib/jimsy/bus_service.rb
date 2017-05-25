require "uri"
require "nokogiri"
require "net/http"

module Jimsy
  class BusService
    require "jimsy/bus_service/departure"
    require "jimsy/bus_service/stop"

    # This MetLink code came from Eoin, who is very nice for sharing it with me.
    DEFAULT_STOPS = {
      am: "7546",
      pm: "5502"
    }.freeze
    DEFAULT_SERVICES = %w[24].freeze

    def self.default_stop
      return DEFAULT_STOPS[:am] if Time.now.hour < 12
      DEFAULT_STOPS[:pm]
    end

    def initialize(stop)
      @stop = stop
    end

    def departures
      page.css(".rt-info-content tr").map do |tr|
        row = tr.css("td").map { |td| td.text.strip }
        next unless row.size == 4
        Departure.new(*row)
      end.compact
    end

    def stop
      Stop.find(@stop)
    end

    private

    # .../departures        returns 20 results
    # .../departures?more=1 returns 40 results
    # .../departures?more=2 returns 60 results
    # .../departures?more=3 returns 80 results
    # .../departures?more=4 returns 100 results
    # etc.
    def page
      @page ||= begin
        uri = URI("https://www.metlink.org.nz/stop/#{stop.id}/departures?more=4")
        response = Net::HTTP.get(uri)
        Nokogiri::HTML(response)
      end
    end
  end
end
