# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class King < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @symbol = " \u265A "
  end
end
