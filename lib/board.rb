# frozen_string_literal: true

require_relative 'displayable.rb'

# contains logic for chess board
class Board
  include Displayable
  attr_reader :data, :active_piece

  def initialize(data = Array.new(8) { Array.new(8) }, active_piece = nil, valid_moves = [], valid_captures = [])
    @data = data
    @active_piece = active_piece
    @valid_moves = valid_moves
    @valid_captures = valid_captures
  end

  def update_active_piece(coordinates)
    @active_piece = data[coordinates[:row]][coordinates[:column]]
  end

  def active_piece_moveable?
    @valid_moves = @active_piece.current_moves(@data)
    @valid_captures = @active_piece.current_captures(@data)
    @valid_moves.size >= 1 || @valid_captures.size >= 1
  end

  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @valid_moves.any?([row, column]) || @valid_captures.any?([row, column])
  end

  # Only Puts Method -> No tests needed
  def to_s
    print_chess_game
  end

  # Script Method -> No tests needed (test inside methods)
  def update(coords)
    update_new_coordinates(coords)
    remove_old_piece
    update_active_piece_location(coords)
    reset_active_piece_values
  end

  # Tested
  def update_new_coordinates(coords)
    @data[coords[:row]][coords[:column]] = @active_piece
  end

  # Tested
  def remove_old_piece
    square = @active_piece.location
    @data[square[0]][square[1]] = nil
  end

  def update_active_piece_location(coords)
    @active_piece.update_location(coords[:row], coords[:column])
  end

  def reset_active_piece_values
    @active_piece = nil
    @valid_moves = []
    @valid_captures = []
  end

  # Completed Tests
  def initial_placement
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
  end

  private

  def initial_pawn_row(color, number)
    8.times do |index|
      @data[number][index] = Pawn.new({ color: color, location: [number, index] })
    end
  end

  def initial_row(color, number)
    @data[number] = [
      Rook.new({ color: color, location: [number, 0] }),
      Knight.new({ color: color, location: [number, 1] }),
      Bishop.new({ color: color, location: [number, 2] }),
      Queen.new({ color: color, location: [number, 3] }),
      King.new({ color: color, location: [number, 4] }),
      Bishop.new({ color: color, location: [number, 5] }),
      Knight.new({ color: color, location: [number, 6] }),
      Rook.new({ color: color, location: [number, 7] })
    ]
  end
end
