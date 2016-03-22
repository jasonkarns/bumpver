lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

module Bumpver
end

require 'bumpver/version'
require 'bumpver/version_file'
