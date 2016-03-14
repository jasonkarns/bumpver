require 'rake/tasklib'
require 'bumper/version'
require 'bumper/version_file'

#TODO mute shell commands
#TODO dry-run flag
#TODO verbose flag
#TODO default version from path or something

module Bumper
  class Task < ::Rake::TaskLib
    attr_reader :name

    def initialize(name, opts)
      @name = name
      commit = opts.fetch(:commit, true)
      current_version = opts.fetch(:version)
      level = opts.fetch(:level, name)
      path = opts.fetch(:path)

      @file = VersionFile.new(path)
      @next_version = Version.parse(current_version).next(level)
      @description = "Bump #{level} version to #@next_version."

      define
      enhance_to_commit if commit
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
    def initialize(namespace=:version, opts)
      @namespace = namespace
      @commit = opts.fetch(:commit, true)
      @current_version = opts.fetch(:version)
      @path = opts.fetch(:path)
      define
    end

    private

    def define
      desc "Print current gem version: #@current_version."
      task @namespace do
        puts @current_version
      end

      namespace @namespace do
        Task.new :major, :path => @path, :version => @current_version, :commit => @commit
        Task.new :minor, :path => @path, :version => @current_version, :commit => @commit
        Task.new :patch, :path => @path, :version => @current_version, :commit => @commit

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
end
