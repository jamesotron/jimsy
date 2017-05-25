require "thor"
require "jimsy/git"
require "jimsy/bus_service"

module Jimsy
  class CLI < Thor
    desc "bus", "List the next bunch of busses for a given stop"
    option :stop_number, default: BusService.default_stop
    option :services, default: BusService::DEFAULT_SERVICES, type: :array
    option :filter, default: true, type: :boolean
    def bus
      service = BusService.new(options[:stop_number])
      service.departures.each do |departure|
        if departure.member?(options[:services])
          say(departure.to_s, :yellow)
        else
          next if options[:filter]
          say(departure.to_s)
        end
      end
    end

    desc "git SUBCOMMAND ...ARGS", "git stuff"
    subcommand :git, Git
  end
end
