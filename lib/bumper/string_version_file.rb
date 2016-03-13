require 'pathname'

module Bumper
  class StringVersionFile

    def initialize(path)
      @file = Pathname.new path
    end

    def bump_to(version)
      File.write(@file, bumped(version))
    end

    private

    def bumped(version)
      @file.read.
        sub(/(VERSION\s*=")[\w.+\-]+(.*)/) { [$1, version.to_s, $2].join }
    end
  end
end
