# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Rook < Piece
  attr_reader :color, :symbol

  def initialize(color)
    super(color)
    @symbol = " \u265C "
  end
end
