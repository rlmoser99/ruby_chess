# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :moves, :location

  def initialize(args)
    super(args)
    @symbol = " \u265F "
    @location = args[:location]
    @moves = []
    @moved = false
  end

  # add valid move for en passant
  def update_moves
    row = @location[0]
    column = @location[1]
    if color == :white
      @moves << [row - 2, column] unless @moved
      @moves << [row - 1, column]
    else
      @moves << [row + 2, column] unless @moved
      @moves << [row + 1, column]
    end
  end
end
