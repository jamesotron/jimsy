module Jimsy
  class Git
    class PushService

      def initialize(args)
        @args = args
      end

      def upstream_branch_name
        @upstream_branch_name ||= `git for-each-ref --format='%(upstream:short)' #{symbolic_ref(false)}`.strip
      end

      def current_branch_name
        @current_branch_name ||= symbolic_ref(true)
      end

      def remotes
        `git remote -v`
          .each_line
          .map(&:strip)
          .map(&:split)
          .each_with_object({}) do |(name, url, _), hash|
            hash[name] = url
          end
      end

      def remote_names
        remotes.keys
      end

      def push!(additional_arguments = [])
        exec(*%w[git push].concat(additional_arguments).concat(args))
      end

      private

      attr_reader :args

      def symbolic_ref(short)
        arg = short ? "--short" : "-q"
        `git symbolic-ref #{arg} HEAD`.strip
      end

    end
  end
end
