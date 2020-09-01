# frozen_string_literal: true

# logic for each chess piece
class Piece
  attr_reader :location

  def initialize(args)
    @color = args[:color]
    @location = args[:location]
    @moves = []
    @moved = false
  end

  # Tested
  def update_location(row, column)
    @location = [row, column]
    @moved = true
  end
end
