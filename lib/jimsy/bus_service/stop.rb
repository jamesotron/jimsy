require "csv"
require "forwardable"

module Jimsy
  class BusService
    # Bus stop information downloaded from
    # https://www.metlink.org.nz/customer-services/general-transit-file-specification/

    Stop = Struct.new(:id, :code, :name, :description, :latitude, :logitude,
                      :zone_id, :stop_url, :location_type, :parent_station,
                      :timezone)

    class Stop
      CSV_PATH = File.expand_path("../../../../data/stops.txt", __FILE__).freeze

      class << self
        def all
          @all ||= CSV
                   .read(CSV_PATH)
                   .map { |row| Stop.new(*row) }
                   .reject { |stop| stop.id == "stop_id" }
        end

        def find(id)
          all.find { |stop| stop.id == id }
        end
      end
    end
  end
end
