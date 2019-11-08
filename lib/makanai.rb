require "makanai/version"

module Makanai
  def self.root
    File.dirname __dir__
  end

  class Error < StandardError; end
  # Your code goes here...
end
