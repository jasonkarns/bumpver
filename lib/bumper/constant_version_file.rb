require 'bumper/version_file'

module Bumper
  class ConstantVersionFile < VersionFile

    private

    def bumped(version)
      @file.read.
        sub(/(MAJOR\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, version.major, $2].join }.
        sub(/(MINOR\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, version.minor, $2].join }.
        sub(/(PATCH\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, version.patch, $2].join }.
        sub(/(PRE\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, 'nil', $2].join }.
        sub(/(BUILD\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, 'nil', $2].join }
    end
  end
end
