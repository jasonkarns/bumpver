require 'pathname'
require 'bumper/utility'

module Bumper
  class VersionFile
    def initialize(path)
      @file = Pathname.new path
    end

    def bump_to(version)
      File.write(@file, bumped.to(version))
    end

    def to_s
      @file.to_s
    end

    private

    def bumped
      contents = @file.read
      if contents =~ /MAJOR\s*=/
        BumpedComponents.new(contents)
      else
        BumpedString.new(contents)
      end
    end

    class Bumped
      include Utility
      def initialize(contents)
        @contents = contents
      end
    end

    class BumpedString < Bumped
      def to(version)
        replace(@contents, 'VERSION', "'#{version}'")
      end
    end

    class BumpedComponents < Bumped
      def to(version)
        replace(replace(replace(replace(replace(
          @contents,
          'MAJOR', version.major),
          'MINOR', version.minor),
          'PATCH', version.patch),
          'PRE', 'nil'),
          'BUILD', 'nil')
      end
    end
  end
end
