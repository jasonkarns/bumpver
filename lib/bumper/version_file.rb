require 'pathname'
require 'bumper/utility'

module Bumper
  class VersionFile
    include Utility

    def initialize(path)
      @file = Pathname.new path
    end

    def bump_to(version)
      File.write(@file, bumped(version))
    end
  end
end
