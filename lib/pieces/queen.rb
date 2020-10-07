# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Queen < Piece
  attr_reader :color, :symbol

  def initialize(_board, args)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265B "
  end

  private

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
