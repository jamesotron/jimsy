require "uri"

module Jimsy
  class Git
    class CloneService
      SAFE_HOSTS = %w[github.com bitbucket.org].freeze

      def initialize(uri, code_dir)
        @raw_uri  = uri
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

      attr_reader :raw_uri, :code_dir

      def uri
        return @parsed_uri if @parsed_uri
        return @parsed_uri = parse_git_uri if git_uri?
        @parsed_uri = URI(raw_uri)
      end

      def parse_git_uri
        URI("ssh://#{raw_uri.sub(':', '/')}")
      end

      def git_uri?
        raw_uri =~ /^git@/
      end

      def uri_dir
        File.dirname(uri.path)
      end

      def uri_repo
        File.basename(uri.path, ".git")
      end
    end
  end
end
