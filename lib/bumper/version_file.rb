require 'pathname'

module Bumper
  class VersionFile

    def initialize(path)
      @file = Pathname.new path
    end

    def bump_to(version)
      File.write(@file, bumped(version))
    end

    private

    def replace(string, constant, value)
      string.sub(/(#{constant}\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, value, $2].join }
    end
  end
end

