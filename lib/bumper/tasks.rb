require 'rake/tasklib'
require 'bumper/version'
require 'bumper/version_file'

module Bumper
  class Tasks < ::Rake::TaskLib
    class << self
      def install(path, version)
        new(VersionFile.new(path), Version.parse(version)).install
      end
    end

    attr_reader :file, :version

    def initialize(file, version)
      @file = file
      @version = version
    end

    def install
      desc "Print current gem version: #{version}."
      task :version do
        puts version
      end

      namespace :version do
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
