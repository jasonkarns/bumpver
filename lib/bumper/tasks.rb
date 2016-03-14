require 'rake/tasklib'
require 'bumper/version'
require 'bumper/version_file'

module Bumper
  class Task < ::Rake::TaskLib
    def initialize(name, path, current_version, level: name)
      @name = name
      @file = VersionFile.new(path)
      @next_version = Version.parse(current_version).next(level)
      @description = "Bump #{level} version to #@next_version."

      define
    end

    private

    def define
      desc @description
      task @name do
        @file.bump_to @next_version
        commit
      end
    end

    def commit
      sh %Q{git commit -m "Version #@next_version" -- #@file}
    rescue => e
      sh %Q{git checkout -- #@file}
      raise e
    end
  end

  class Tasks < ::Rake::TaskLib
    def initialize(path, current_version, namespace: :version)
      @path = path
      @namespace = namespace
      @current_version = current_version
      define
    end

    private

    def define
      desc "Print current gem version: #@current_version."
      task @namespace do
        puts @current_version
      end

      namespace @namespace do
        Task.new(:major, @path, @current_version)
        Task.new(:minor, @path, @current_version)
        Task.new(:patch, @path, @current_version)

        task :guard_clean do
          guard_clean
        end
      end
    end


    def guard_clean
      clean? && committed? or raise("There are files that need to be committed first.")
    end

    def clean?
      sh "git diff --exit-code"
    end

    def committed?
      sh "git diff-index --quiet --cached HEAD"
    end

  end
end
