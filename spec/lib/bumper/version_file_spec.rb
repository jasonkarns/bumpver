require 'tempfile'
require 'bumper/version'
require 'spec_helper'
require 'bumper/version_file'

module Bumper
  describe VersionFile do
    def bumped_file_contents
      tempfile.rewind
      tempfile.read
    end

    describe "#bump_to" do
      Given(:file) { VersionFile.new tempfile }
      Given(:tempfile) { Tempfile.new("version.rb").tap { |f| f.write(contents) and f.rewind } }

      context "single version string" do
        Given(:contents) { 'VERSION="1.2.3"' }
        When { file.bump_to Version::Conversions.Version("4.5.6") }
        Then { bumped_file_contents == "VERSION='4.5.6'" }
      end

      context "separate component constants" do
        context "with only major.minor.patch" do
          Given(:contents) { <<-VER }
          module VERSION
            MAJOR=1
            MINOR=2
            PATCH=3
          end
          VER

          When { file.bump_to Version::Conversions.Version("4.5.6") }
          Then { bumped_file_contents == <<-VER }
          module VERSION
            MAJOR=4
            MINOR=5
            PATCH=6
          end
          VER
        end

        context "with pre and build" do
          Given(:contents) { <<-VER }
            module VERSION
              MAJOR=1
              MINOR=2
              PATCH=3
              PRE='alpha'
              BUILD=42
            end
          VER

          When { file.bump_to Version::Conversions.Version("4.5.6") }
          Then { bumped_file_contents == <<-VER }
            module VERSION
              MAJOR=4
              MINOR=5
              PATCH=6
              PRE=nil
              BUILD=nil
            end
          VER
        end
      end
    end
  end
end
