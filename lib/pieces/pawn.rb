# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :moves, :location, :captures

  def initialize(args)
    super(args)
    @symbol = " \u265F "
    @location = args[:location]
    @moves = []
    @captures = []
    @moved = false
  end

  # Tested
  # add valid move for en passant
  def update_moves
    @moves = []
    movement = color == :white ? -1 : 1
    @moves << [@location[0] + movement, @location[1]]
    additional_new_move unless @moved
  end

  # Tested
  def update_captures
    @captures = []
    row = @location[0]
    column = @location[1]
    movement = color == :white ? -1 : 1
    @captures << [row + movement, column - 1] if column >= 1
    @captures << [row + movement, column + 1] if column <= 6
  end

  private

  def additional_new_move
    movement = color == :white ? -2 : 2
    @moves << [@location[0] + movement, @location[1]]
  end
end
