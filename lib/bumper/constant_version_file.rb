require 'bumper/version_file'

module Bumper
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
