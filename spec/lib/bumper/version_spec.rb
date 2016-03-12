require 'spec_helper'
require 'bumper/version'

module Bumper
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

  end
end
