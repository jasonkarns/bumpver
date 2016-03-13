require 'spec_helper'
require 'bumper/utility'

module Bumper
  describe Utility do
    describe "replace" do
      def replaced
        described_class.replace(string, replace, value)
      end

      Given(:replace) { "FOO" }
      Given(:value) { "'4.5.6'" }

      context "without spaces" do
        Given(:string) { "FOO='1.2.3'" }
        Then { replaced == "FOO='4.5.6'" }
      end

      context "with spaces" do
        Given(:string) { "FOO =  '1.2.3'" }
        Then { replaced == "FOO =  '4.5.6'" }
      end

      context "with double quotes" do
        Given(:string) { 'FOO = "1.2.3"' }
        Then { replaced == "FOO = '4.5.6'" }
      end

      context "with single quotes" do
        Given(:string) { "FOO = '1.2.3'" }
        Then { replaced == "FOO = '4.5.6'" }
      end
    end
  end
end
