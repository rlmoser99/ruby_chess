# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Bishop < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @symbol = " \u265D "
  end
end
