module Jimsy
  class Git < Thor
    require "jimsy/git/clone_service"
    require "jimsy/git/push_service"

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize

    desc "clone URI", "clone A git repo"
    option :code_dir, default: "~/Dev"
    def clone(uri)
      service = Git::CloneService.new(uri, options[:code_dir])

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

    desc "push", "try really hard to push to origin"
    def push(*args)
      service = Git::PushService.new(args)

      return service.push! unless service.upstream_branch_name.empty?

      if service.remote_names.member?("origin")
        say("Warning: this branch doesn't track origin. Pushing there", :yellow)
        return service.push!(["--set-upstream", "origin", service.current_branch_name])
      end

      say("Warning: this branch doesn't track a remote branch,", :red)
      say("         additionally there is no 'origin' remote.", :red)

      remotes = service.remotes
      if remotes.any?
        puts
        say("Currently configured remotes are:", :yellow)
        remotes.each do |name, url|
          puts("#{name}\t#{url}")
        end
      end

      say("         you'll need to add one manually.", :red)
    end
  end
end
