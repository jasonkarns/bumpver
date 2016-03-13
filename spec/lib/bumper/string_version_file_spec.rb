require 'tempfile'
require 'bumper/version'
require 'spec_helper'
require 'bumper/string_version_file'

module Bumper
  describe StringVersionFile do
    def bumped_file_contents
      tempfile.rewind
      tempfile.read
    end

    describe "#bump_to" do
      Given(:tempfile) {
        Tempfile.new("version.rb").tap do |f|
          f.write contents
          f.rewind
        end
      }
      Given(:file) { described_class.new tempfile }

      Given(:contents) { 'VERSION="1.2.3"' }
      When { file.bump_to Version::Conversions.Version("4.5.6") }
      Then { bumped_file_contents == "VERSION='4.5.6'" }
    end
  end
end
