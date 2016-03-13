module Bumper
  class Version
    class << self
      def from_constants(v)
        new(
          (v::MAJOR if v.const_defined?(:MAJOR)),
          (v::MINOR if v.const_defined?(:MINOR)),
          (v::PATCH if v.const_defined?(:PATCH)),
          (v::PRE if v.const_defined?(:PRE)),
          (v::BUILD if v.const_defined?(:BUILD))
        )
      end

      def from_string(v)
        v, _, build = v.partition('+')
        v, _, pre = v.partition('-')
        major, _, v = v.partition('.')
        minor, _, v = v.partition('.')
        patch, _, v = v.partition('.')
        new(major.to_i, minor.to_i, patch.to_i, pre, build)
      end
    end

    attr_reader :major, :minor, :patch, :pre, :build

    def initialize(major=0, minor=0, patch=0, pre=nil, build=nil)
      @major = major
      @minor = minor
      @patch = patch
      @pre = String pre
      @build = String build
    end

    def ==(other)
      major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        pre == other.pre &&
        build == other.build
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

    public

    module Conversions
      module_function

      def Version(v)
        if v.is_a?(Module) && v.const_defined?(:MAJOR)
          Version.from_constants(v)
        else
          Version.from_string v.to_s
        end
      end
    end

  end
end
