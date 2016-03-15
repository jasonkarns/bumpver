require 'rubygems'
require 'rake/tasklib'
require 'bumpver/version'
require 'bumpver/version_file'

#TODO mute shell commands
#TODO dry-run flag
#TODO verbose flag

module Bumpver
  class Task < ::Rake::TaskLib
    def initialize(name, options={})
      options = Options.new(options) unless options.is_a?(Options)

      @name = name
      level = options.level || name

      @file = VersionFile.new(options.path)
      @next_version = Version.parse(options.current_version).next(level)
      @description = "Bump #{level} version to #@next_version."

      define
      enhance_to_commit if options.commit?
    end

    private

    def define
      desc @description
      task @name do
        @file.bump_to @next_version
      end
    end

    def enhance_to_commit
      Rake::Task[@name].enhance([:guard_clean]) do
        commit
      end
    end

    def commit
      sh %Q{git add -- #@file}
      sh %Q{git commit --message="Version #@next_version"}
    rescue => e
      sh %Q{git checkout -- #@file}
      raise e
    end
  end

  class Tasks < ::Rake::TaskLib
    def initialize(options={})
      @options = Options.new(options) unless options.is_a?(Options)

      @namespace = @options.namespace
      @current_version = @options.current_version
      define
    end

    private

    def define
      desc "Print current gem version: #@current_version."
      task @namespace do
        puts @current_version
      end

      namespace @namespace do
        Task.new :major, @options
        Task.new :minor, @options
        Task.new :patch, @options

        task :guard_clean do
          guard_clean
        end
      end
    end

    def guard_clean
      clean? or raise("There are files that need to be committed first.")
    end

    def clean?
      sh "git diff --quiet --exit-code"
    end
  end

  private

  class Options
    def initialize(opts)
      @opts = opts
    end

    def commit?
      @opts.fetch(:commit, true)
    end

    def current_version
      @opts.fetch(:version, gem.version)
    end

    def level
      @opts.fetch(:level, nil)
    end

    def namespace
      @opts.fetch(:namespace, :version)
    end

    def path
      @opts.fetch(:path, derived_path)
    end

    private

    def gem
      @gem ||= Gem::Specification.load Dir["*.gemspec"].first
      #TODO handle where gemspec doesn't exist
    end

    def derived_path
      "lib/#{gem.name.gsub('-', '_')}/version.rb"
      #TODO handle error where file doesn't exist
    end
  end
end
