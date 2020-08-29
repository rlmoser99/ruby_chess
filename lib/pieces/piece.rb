# frozen_string_literal: true

# logic for each chess piece
class Piece
  def initialize(args)
    @color = args[:color]
    @location = args[:location]
    @moves = []
    @moved = false
  end
end
