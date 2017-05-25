require "thor"
require "jimsy/clone_service"
require "jimsy/bus_service"

module Jimsy
  class CLI < Thor
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize

    desc "clone URI", "clone A git repo"
    option :code_dir, default: "~/Dev"
    def clone(uri)
      service = CloneService.new(uri, options[:code_dir])

      if service.target_path_exists?
        say("Repo #{service.target_path} already exists.", :red)
        exit(1)
      end

      unless service.safe_host?
        prompt = format("About to clone into %p. Are you sure?", service.target_path)
        unless yes?(prompt, :yellow)
          say("Giving up", :red)
          exit(0)
        end
      end

      service.clone!
    end

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
  end
end
