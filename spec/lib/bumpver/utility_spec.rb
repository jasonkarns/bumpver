require 'spec_helper'
require 'bumpver/utility'

module Bumpver
  describe Utility do
    describe "#replace" do
      include Utility

      context "string" do
        context "without spaces" do
          Then { replace("FOO='1.2.3'", "FOO", "'4.5.6'") == "FOO='4.5.6'" }
        end

        context "with spaces" do
          Then { replace("FOO =  '1.2.3'" , "FOO", "'4.5.6'") == "FOO =  '4.5.6'" }
        end

        context "with double quotes" do
          Then { replace('FOO = "1.2.3"' , "FOO", "'4.5.6'") == "FOO = '4.5.6'" }
        end

        context "with single quotes" do
          Then { replace("FOO = '1.2.3'" , "FOO", "'4.5.6'") == "FOO = '4.5.6'" }
        end
      end

      context "number" do
        context "without spaces" do
          Then { replace("FOO='1.2.3'", "FOO", 42) == "FOO=42" }
        end

        context "with spaces" do
          Then { replace("FOO =  '1.2.3'" , "FOO", "42") == "FOO =  42" }
        end
      end

      context "nil" do
        context "without spaces" do
          Then { replace("FOO='1.2.3'", "FOO", "nil") == "FOO=nil" }
        end

        context "with spaces" do
          Then { replace("FOO =  '1.2.3'" , "FOO", "nil") == "FOO =  nil" }
        end
      end
    end
  end
end
