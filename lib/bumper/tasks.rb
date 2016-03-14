require 'rake/tasklib'

module Bumper
  class Tasks < ::Rake::TaskLib
    include Conversions

    class << self
      def install(path, version)
        new(VersionFile.new(path), Version(version)).install
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
        desc "Bump major version to #{version.next_major}."
        task :major do
          file.bump_to version.next_major
        end

        desc "Bump minor version to #{version.next_minor}."
        task :minor do
          file.bump_to version.next_minor
        end

        desc "Bump patch version to #{version.next_patch}."
        task :patch do
          file.bump_to version.next_patch
        end
      end
    end

  end
end
