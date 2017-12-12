require "uri"

module Jimsy
  class Git
    class CloneService
      SAFE_HOSTS = %w[github.com bitbucket.org gitlab.com].freeze

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
        @target_path ||= File.join(code_dir, host_dir, project_dir)
      end

      private

      attr_reader :raw_uri, :code_dir

      def host_dir
        uri.host.to_s.downcase
      end

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

      def project_dir
        File.join(Pathname.new(uri.path).each_filename.map do |component|
          component = component.downcase
          component = component[0..-5] if component.end_with?(".git")
          component
        end)
      end
    end
  end
end
