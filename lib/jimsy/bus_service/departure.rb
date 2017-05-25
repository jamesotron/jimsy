module Jimsy
  class BusService
    class Departure
      TIME_FORMAT = "%s leaves stop %s at %s".freeze
      SOON_FORMAT = "%s leaves stop %s in %s".freeze
      DUE_FORMAT  = "%s is due at stop %s".freeze

      attr_reader :stop, :service, :destination, :time, :extra

      def initialize(stop, service, destination, time, extra)
        @stop        = stop
        @service     = service
        @destination = destination
        @time        = time
        @extra       = extra
      end

      def member?(services)
        services.member?(service)
      end

      # rubocop:disable Metrics/AbcSize
      def to_s
        return format(TIME_FORMAT, service, stop, time) if time?
        return format(SOON_FORMAT, service, stop, time) if soon?
        return format(DUE_FORMAT, service, stop) if due?
        raise "Unknown departure time format"
      end

      private

      def time?
        time =~ /[0-9]+:[0-9]+(am|pm)/
      end

      def due?
        time == "Due"
      end

      def soon?
        time =~ /[0-9]+ mins/
      end

    end
  end
end
