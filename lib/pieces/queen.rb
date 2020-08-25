# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Queen < Piece
  attr_reader :color, :symbol

  def initialize(color)
    super(color)
    @symbol = " \u265B "
  end
end