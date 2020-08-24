# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :symbol, :test

  def initialize(color)
    super(color)
    @symbol = " \u265F "
  end
end
