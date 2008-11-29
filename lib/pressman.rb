require "pressman/board"
require "pressman/stone"
require "pressman/core_extensions"

module Pressman
  class PositionOutOfBoundsError < StandardError; end
  class IllegalMoveError < StandardError; end
  class InvalidPathError < StandardError; end
end
