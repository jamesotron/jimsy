require "thor"
require "jimsy/git"
require "jimsy/bus_service"

module Jimsy
  class CLI < Thor
    # rubocop:disable Metrics/AbcSize

    desc "bus", "List the next bunch of busses for a given stop"
    option :stop_number, default: BusService::DEFAULT_STOP
    option :services, default: BusService::DEFAULT_SERVICES, type: :array
    option :filter, default: true, type: :boolean
    def bus
      service = BusService.new(options[:stop_number])
      service.departures.each do |departure|
        next if options[:filter] && !options[:services].member?(departure.service)

        if options[:services].member?(departure.service)
          say("#{departure.service} leaves in #{departure.when}", :yellow)
        else
          next if options[:filter]
          say("#{departure.service} leaves in #{departure.when}")
        end
      end
    end

    desc "git SUBCOMMAND ...ARGS", "git stuff"
    subcommand :git, Git
  end
end
