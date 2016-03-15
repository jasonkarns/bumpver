module Bumpver
  module Utility

    module_function

    def replace(string, constant, value)
      string.sub(/(#{constant}\s*=\s*)["']?[\w.+\-]+["']?(.*)/) { [$1, value, $2].join }
    end
  end
end
