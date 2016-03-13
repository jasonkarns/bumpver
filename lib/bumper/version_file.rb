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

  class StringVersionFile < VersionFile
    private
    def bumped(version)
      replace(@file.read, 'VERSION', "'#{version}'")
    end
  end

  class ConstantVersionFile < VersionFile
    private
    def bumped(version)
      replace(replace(replace(replace(replace(
        @file.read,
        'MAJOR', version.major),
        'MINOR', version.minor),
        'PATCH', version.patch),
        'PRE', 'nil'),
        'BUILD', 'nil')
    end
  end
end
