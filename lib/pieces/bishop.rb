# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Bishop < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265D "
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
