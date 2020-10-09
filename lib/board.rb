# frozen_string_literal: true

require 'observer'
require_relative 'displayable.rb'

# contains logic for chess board
class Board
  include Displayable
  include Observable
  attr_reader :data, :active_piece, :previous_piece, :black_king, :white_king

  def initialize(data = Array.new(8) { Array.new(8) }, active_piece = nil, valid_moves = [], valid_captures = [])
    @data = data
    @active_piece = active_piece
    @valid_moves = valid_moves
    @valid_captures = valid_captures
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
    @valid_moves = @active_piece.moves
    @valid_captures = @active_piece.captures
    # Remove any move that would put King in check!
    @valid_moves.size >= 1 || @valid_captures.size >= 1
  end

  # Tested
  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @valid_moves.any?([row, column]) || @valid_captures.any?([row, column])
  end

  # Tested
  def piece?(coords)
    @data[coords[:row]][coords[:column]] != nil
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
  def update_new_coordinates(coords)
    @data[coords[:row]][coords[:column]] = @active_piece
  end

  # Tested
  def remove_old_piece
    location = @active_piece.location
    @data[location[0]][location[1]] = nil
  end

  # Tested
  def update_active_piece_location(coords)
    @active_piece.update_location(coords[:row], coords[:column])
  end

  # Tested
  def possible_en_passant?
    @valid_captures.include?(@previous_piece&.location) && en_passant_pawn?
  end

  # def remove_check_moves_captures; end

  # Should this check if either king is in check?
  # Tested
  def check?(king)
    @data.any? do |row|
      row.any? do |square|
        next unless square && square.color != king.color

        square.captures.include?(king.location)
      end
    end
  end

  # def validate_moves?(data, piece)
  #   king = data.select do |row|
  #     next unless row.contains?

  #     row.select do |square|
  #       square && square.color == piece.color && square.class == King
  #     end
  #   end
  #   possible_check?(data, king)
  # end

  # def possible_check?(data, king)
  #   data.any? do |row|
  #     row.any? do |square|
  #       next unless square && square.color != king.color

  #       square.captures.include?(king.location)
  #     end
  #   end
  # end

  # Tested
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil
    @valid_moves = []
    @valid_captures = []
    changed
    notify_observers(self)
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

  # This needs to happen at the beginning of the game...
  # MOVES AND CAPTURES (SELF) ???
  def update_all_moves_captures
    # TESTS ARE FAILING FROM THIS METHOD!!!
    @data.each do |row|
      row.each do |square|
        next unless square

        # binding.pry
        square.current_moves(self)
        # square.current_captures(@data, @previous_piece)
        square.current_captures(self)
      end
    end
  end

  # Only Puts Method -> No tests needed
  def to_s
    print_chess_game
  end

  private

  def initial_pawn_row(color, number)
    8.times do |index|
      @data[number][index] = Pawn.new(self, { color: color, location: [number, index] })
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

  # Checks if there is a possible en_passant capture for game warning.
  def en_passant_capture?(coords)
    @previous_piece&.location == [coords[:row], coords[:column]] && en_passant_pawn?
  end

  # Checks if previous and active pieces are pawns, and if previous is en passant.
  def en_passant_pawn?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F " && @previous_piece.en_passant
  end

  def update_en_passant(coords)
    new_rank = coords[:row] + @active_piece.rank_direction
    new_coords = { row: new_rank, column: coords[:column] }
    update_new_coordinates(new_coords) # -> update board coords of before/after = piece
    @data[coords[:row]][coords[:column]] = nil # capture coords = nil
    remove_old_piece # -> stays the same
    update_active_piece_location(new_coords) # -> active_piece.location = coords of before/after
  end
end
