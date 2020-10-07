# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Rook < Piece
  attr_reader :color, :symbol

  def initialize(_board, args)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265C "
  end

  private

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0]]
  end
end
