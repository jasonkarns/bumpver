require 'bumper/version_file'

module Bumper
  class StringVersionFile < VersionFile

    private

    def bumped(version)
      replace(@file.read, 'VERSION', "'#{version}'")
    end
  end
end
