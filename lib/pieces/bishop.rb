# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Bishop < Piece
  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265D "
    @moves = []
    @captures = []
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
