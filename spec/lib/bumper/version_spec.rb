require 'spec_helper'
require 'bumper/version'

module Bumper
  module SomeVersion
    MAJOR=4
    MINOR=5
    PATCH=6
  end

  describe Version do
    Given(:version) { described_class.new major, minor, patch }
    Given(:major) { 1 }
    Given(:minor) { 2 }
    Given(:patch) { 3 }

    Then { version.to_s == "1.2.3" }
    And { version.major == major }
    And { version.minor == minor }
    And { version.patch == patch }

    Then { version.next_major.to_s == "2.0.0" }
    Then { version.next_minor.to_s == "1.3.0" }
    Then { version.next_patch.to_s == "1.2.4" }

    context "with pre-release version" do
      Given(:version) { described_class.new major, minor, patch, pre }
      Given(:pre) { "alpha" }

      Then { version.to_s == "1.2.3-alpha" }
      And { version.pre == "alpha" }
      Then { version.next_major.to_s == "2.0.0" }
      Then { version.next_minor.to_s == "1.3.0" }
      Then { version.next_patch.to_s == "1.2.4" }
    end

    context "with build version" do
      Given(:version) { described_class.new major, minor, patch, nil, build }
      Given(:build) { "0e65410" }

      Then { version.to_s == "1.2.3+0e65410" }
      And { version.build == "0e65410" }
      Then { version.next_major.to_s == "2.0.0" }
      Then { version.next_minor.to_s == "1.3.0" }
      Then { version.next_patch.to_s == "1.2.4" }
    end

    context "with both pre-release and build version" do
      Given(:version) { described_class.new major, minor, patch, pre, build }
      Given(:pre) { "alpha" }
      Given(:build) { "0e65410" }

      Then { version.to_s == "1.2.3-alpha+0e65410" }
      And { version.pre == "alpha" }
      And { version.build == "0e65410" }
      Then { version.next_major.to_s == "2.0.0" }
      Then { version.next_minor.to_s == "1.3.0" }
      Then { version.next_patch.to_s == "1.2.4" }
    end

    describe "::from_constants" do
      Given(:version) { described_class.from_constants SomeVersion }
      Then { version.to_s == "4.5.6" }
    end

    describe "::from_string" do
      Given(:version) { described_class.from_string string }

      context "with only major" do
        Given(:string) { "42" }
        Then { version.to_s == "42.0.0" }
      end

      context "with major.minor" do
        Given(:string) { "42.7" }
        Then { version.to_s == "42.7.0" }
      end

      context "with major.minor.patch" do
        Given(:string) { "42.7.5" }
        Then { version.to_s == "42.7.5" }
      end

      context "with pre-release" do
        Given(:string) { "42.7.5-alpha" }
        Then { version.to_s == "42.7.5-alpha" }
      end

      context "with build" do
        Given(:string) { "42.7.5+0e65410" }
        Then { version.to_s == "42.7.5+0e65410" }
      end

      context "with pre-release and build" do
        Given(:string) { "42.7.5-alpha+0e65410" }
        Then { version.to_s == "42.7.5-alpha+0e65410" }
      end
    end
  end

  describe "::Version" do
    Given { allow(Version).to receive(:from_string) }
    Given { allow(Version).to receive(:from_constants) }

    context "with string" do
      When { Version::Conversions.Version("1.2.3") }
      Then { expect(Version).to have_received(:from_string).with("1.2.3") }
    end

    context "with constant" do
      When { Version::Conversions.Version(SomeVersion) }
      Then { expect(Version).to have_received(:from_constants).with(SomeVersion) }
    end
  end
end
