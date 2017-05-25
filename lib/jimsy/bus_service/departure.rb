module Jimsy
  class BusService
    class Departure
      TIME_FORMAT = "%s leaves at %s.".freeze
      SOON_FORMAT = "%s leaves in %s.".freeze
      DUE_FORMAT  = "%s is due.".freeze

      attr_reader :service, :destination, :time, :extra

      def initialize(service, destination, time, extra)
        @service     = service
        @destination = destination
        @time        = time
        @extra       = extra
      end

      def member?(services)
        services.member?(service)
      end

      def to_s
        return format(TIME_FORMAT, service, time) if time?
        return format(SOON_FORMAT, service, time) if soon?
        return format(DUE_FORMAT, service) if due?
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
