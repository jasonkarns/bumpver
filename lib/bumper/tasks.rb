require 'rake/tasklib'
require 'bumper/version'
require 'bumper/version_file'

module Bumper
  class Tasks < ::Rake::TaskLib
    attr_reader :file, :version

    def initialize(path, version, namespace: :version)
      @file = VersionFile.new(path)
      @version = Version.parse(version)
      @namespace = namespace
      define
    end

    def define
      desc "Print current gem version: #{version}."
      task @namespace do
        puts version
      end

      namespace @namespace do
        define_task(:major)
        define_task(:minor)
        define_task(:patch)

        task :guard_clean do
          guard_clean
        end
      end
    end

    private

    def define_task(level)
      next_version = version.next(level)

      desc "Bump #{level} version to #{next_version}."
      task level => :guard_clean do
        bump_to next_version
        commit_as next_version
      end
    end

    def bump_to(version)
      file.bump_to version
    end

    def commit_as(version)
      sh %Q{git commit -m "Version #{version}" -- #{file}}
    rescue => e
      sh %Q{git checkout -- #{file}}
      raise e
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
