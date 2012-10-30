module Pod
  class Command
    class Outdated < Command
      self.summary = 'Show outdated project dependencies'

      self.description = <<-DESC
        Shows the outdated pods in the current Podfile.lock, but only those from
        spec repos, not those from local/external sources or `:head' versions.
      DESC

      def self.options
        [["--no-update", "Skip running `pod repo update` before install"]].concat(super)
      end

      def initialize(argv)
        config.skip_repo_update = argv.flag?('update', true)
        super
      end

      def run
        verify_podfile_exists!
        verify_lockfile_exists!

        sandbox = Sandbox.new(config.project_pods_root)
        resolver = Resolver.new(config.podfile, config.lockfile, sandbox)
        resolver.update_mode = true
        resolver.update_external_specs = false
        resolver.resolve

        #TODO: the command report new dependencies (added to by updated ones)
        # as updates.

        names = resolver.pods_to_install - resolver.pods_from_external_sources
        specs = resolver.specs.select do |spec|
          names.include?(spec.name) && !spec.version.head?
        end

        if specs.empty?
          puts "No updates are available.".yellow
        else
          puts "The following updates are available:".green
          puts "  - " << specs.join("\n  - ") << "\n"
        end
      end
    end
  end
end

