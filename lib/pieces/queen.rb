# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Queen < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265B "
  end

  def current_moves(board)
    find_valid_moves(board).compact.flatten(1)
  end

  def current_captures(board)
    find_valid_captures(board).compact
  end

  private

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
