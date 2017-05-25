require "uri"

module Jimsy
  class Git
    class CloneService
      SAFE_HOSTS = %w[github.com bitbucket.org].freeze

      def initialize(uri, code_dir)
        @uri      = URI(uri)
        @code_dir = File.expand_path(code_dir)
      end

      def safe_host?
        SAFE_HOSTS.member?(uri.host)
      end

      def clone!
        system("git clone #{uri} #{target_path}")
      end

      def target_path_exists?
        Dir.exist?(target_path)
      end

      def target_path
        @target_path ||= File.join(code_dir, uri.host, uri_dir, uri_repo)
      end

      private

      attr_reader :uri, :code_dir

      def uri_dir
        File.dirname(uri.path)
      end

      def uri_repo
        File.basename(uri.path, ".git")
      end
    end
  end
end
