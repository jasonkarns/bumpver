module Bumper
  class Version

    attr_reader :major, :minor, :patch, :pre, :build

    def initialize(major=0, minor=0, patch=0, pre=nil, build=nil)
      @major = major
      @minor = minor
      @patch = patch
      @pre = String pre
      @build = String build
    end

    def to_s
      [major, minor, patch].join('.') + append('-', pre) + append('+', build)
    end

    def next_major
      self.class.new(major+1, 0, 0)
    end

    def next_minor
      self.class.new(major, minor+1, 0)
    end

    def next_patch
      self.class.new(major, minor, patch+1)
    end

    private

    def append(separator, component)
      "#{separator unless component.empty?}#{component}"
    end

  end
end
