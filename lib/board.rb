# frozen_string_literal: true

require 'observer'
require_relative 'displayable.rb'

# contains logic for chess board
class Board
  include Displayable
  include Observable
  attr_reader :data, :active_piece, :previous_piece, :black_king, :white_king

  def initialize(data = Array.new(8) { Array.new(8) }, active_piece = nil)
    @data = data
    @active_piece = active_piece
    @previous_piece = nil
    @black_king = nil
    @white_king = nil
  end

  # Tested
  def update_active_piece(coordinates)
    @active_piece = data[coordinates[:row]][coordinates[:column]]
  end

  # Tested
  def active_piece_moveable?
    @active_piece.moves.size >= 1 || @active_piece.captures.size >= 1
  end

  # Tested
  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @active_piece.moves.any?([row, column]) ||
      @active_piece.captures.any?([row, column])
  end

  # Tested
  def valid_piece?(coords, color)
    piece = @data[coords[:row]][coords[:column]]
    piece&.color == color
  end

  # Script Method -> No tests needed (test inside methods)
  def update(coords)
    if en_passant_capture?(coords)
      update_en_passant(coords)
    else
      update_new_coordinates(coords)
      remove_old_piece
      update_active_piece_location(coords)
    end
    reset_board_values
  end

  # Tested
  def possible_en_passant?
    @active_piece&.captures&.include?(@previous_piece&.location) &&
      en_passant_pawn?
  end

  # Tested
  def check?(color)
    king = color == :white ? @white_king : @black_king
    @data.any? do |row|
      row.any? do |square|
        next unless square && square.color != king.color

        square.captures.include?(king.location)
      end
    end
  end

  # Tested
  def initial_placement
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
    @white_king = @data[7][4]
    @black_king = @data[0][4]
    update_all_moves_captures
  end

  # Only Puts Method -> No tests needed
  def to_s
    print_chess_game
  end

  private

  def initial_pawn_row(color, number)
    8.times do |index|
      @data[number][index] =
        Pawn.new(self, { color: color, location: [number, index] })
    end
  end

  def initial_row(color, number)
    @data[number] = [
      Rook.new(self, { color: color, location: [number, 0] }),
      Knight.new(self, { color: color, location: [number, 1] }),
      Bishop.new(self, { color: color, location: [number, 2] }),
      Queen.new(self, { color: color, location: [number, 3] }),
      King.new(self, { color: color, location: [number, 4] }),
      Bishop.new(self, { color: color, location: [number, 5] }),
      Knight.new(self, { color: color, location: [number, 6] }),
      Rook.new(self, { color: color, location: [number, 7] })
    ]
  end

  # Tested (private, but used in a public script method)
  def update_new_coordinates(coords)
    row = coords[:row]
    column = coords[:column]
    delete_observer(@data[row][column]) if @data[row][column]
    @data[row][column] = @active_piece
  end

  # Tested (private, but used in a public script method)
  def remove_old_piece
    location = @active_piece.location
    @data[location[0]][location[1]] = nil
  end

  # Tested (private, but used in a public script method)
  def update_active_piece_location(coords)
    @active_piece.update_location(coords[:row], coords[:column])
  end

  # Tested (private, but used in a public script method)
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil
    changed
    notify_observers(self)
  end

  # Used at beginning of game to update all pieces moves/captures
  def update_all_moves_captures
    @data.each do |row|
      row.each do |square|
        next unless square

        square.update(self)
      end
    end
  end

  # Checks if there is a possible en_passant capture for game warning.
  def en_passant_capture?(coords)
    @previous_piece&.location == [coords[:row], coords[:column]] &&
      en_passant_pawn?
  end

  # Checks if previous & active pieces are pawns, and if previous is en passant.
  def en_passant_pawn?
    two_pawns? && @active_piece.en_passant_rank? && @previous_piece.en_passant
  end

  # Checks is both pieces are pawns
  def two_pawns?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F "
  end

  # Handles extra piece placement during an en_passant capture
  def update_en_passant(coords)
    new_rank = coords[:row] + @active_piece.rank_direction
    new_coords = { row: new_rank, column: coords[:column] }
    update_new_coordinates(new_coords)
    remove_en_passant_capture(coords)
    update_active_piece_location(new_coords)
  end

  # Removes old piece and observer during en_passant capture
  def remove_en_passant_capture(coords)
    row = coords[:row]
    column = coords[:column]
    delete_observer(@data[row][column])
    @data[row][column] = nil
    remove_old_piece
  end
end
