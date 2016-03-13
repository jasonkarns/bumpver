require 'tempfile'
require 'bumper/version'
require 'spec_helper'
require 'bumper/constant_version_file'

module Bumper
  describe ConstantVersionFile do
    def file_contents
      tempfile.rewind
      tempfile.read
    end

    Given(:file) { described_class.new tempfile }
    Given(:tempfile) { Tempfile.new("version.rb").tap { |f| f.write(contents) and f.rewind } }

    describe "bump_to" do
      context "without spaces" do
        Given(:contents) { <<-VER }
          module VERSION
            MAJOR=1
            MINOR=2
            PATCH=3
          end
        VER

        When { file.bump_to Version::Conversions.Version("4.5.6") }
        Then { file_contents == <<-VER }
          module VERSION
            MAJOR=4
            MINOR=5
            PATCH=6
          end
        VER
      end

      context "with spaces" do
        Given(:contents) { <<-VER }
          module VERSION
            MAJOR = 1
            MINOR = 2
            PATCH = 3
          end
        VER

        When { file.bump_to Version::Conversions.Version("4.5.6") }
        Then { file_contents == <<-VER }
          module VERSION
            MAJOR = 4
            MINOR = 5
            PATCH = 6
          end
        VER
      end

      context "with pre and build" do
        context "with single quotes" do
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
          Then { file_contents == <<-VER }
            module VERSION
              MAJOR=4
              MINOR=5
              PATCH=6
              PRE=nil
              BUILD=nil
            end
          VER
        end

        context "with double quotes" do
          Given(:contents) { <<-VER }
            module VERSION
              MAJOR=1
              MINOR=2
              PATCH=3
              PRE="alpha"
              BUILD=56
            end
          VER

          When { file.bump_to Version::Conversions.Version("4.5.6") }
          Then { file_contents == <<-VER }
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
