# frozen_string_literal: true

require 'observer'
require_relative 'displayable'

# contains logic for chess board
class Board
  include Displayable
  include Observable
  attr_reader :black_king, :white_king, :mode
  attr_accessor :data, :active_piece, :previous_piece

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data
    @active_piece = params[:active_piece]
    @previous_piece = params[:previous_piece]
    @black_king = params[:black_king]
    @white_king = params[:white_king]
    @mode = params[:mode]
  end

  def update_active_piece(coordinates)
    @active_piece = data[coordinates[:row]][coordinates[:column]]
  end

  def active_piece_moveable?
    @active_piece.moves.size >= 1 || @active_piece.captures.size >= 1
  end

  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @active_piece.moves.any?([row, column]) ||
      @active_piece.captures.any?([row, column])
  end

  def valid_piece?(coords, color)
    piece = @data[coords[:row]][coords[:column]]
    piece&.color == color
  end

  def update(coords)
    type = movement_type(coords)
    movement = MovementFactory.new(type).build
    movement.update_pieces(self, coords)
    reset_board_values
  end

  def movement_type(coords)
    if en_passant_capture?(coords)
      'EnPassant'
    elsif pawn_promotion?(coords)
      'PawnPromotion'
    elsif castling?(coords)
      'Castling'
    else
      'Basic'
    end
  end

  # resets board and notifes all of the pieces to update moves/captures
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil
    changed
    notify_observers(self)
  end

  def possible_en_passant?
    @active_piece&.captures&.include?(@previous_piece&.location) &&
      en_passant_pawn?
  end

  def possible_castling?
    @active_piece.symbol == " \u265A " && castling_moves?
  end

  def king_in_check?(color)
    king = color == :white ? @white_king : @black_king
    pieces = @data.flatten(1).compact
    pieces.any? do |piece|
      next unless piece.color != king.color

      piece.captures.include?(king.location)
    end
  end

  def random_black_piece
    pieces = @data.flatten(1).compact
    black_pieces = pieces.select do |piece|
      next unless piece.color == :black

      piece.moves.size.positive? || piece.captures.size.positive?
    end
    location = black_pieces.sample.location
    { row: location[0], column: location[1] }
  end

  def random_black_move
    possibilities = @active_piece.moves + @active_piece.captures
    location = possibilities.sample
    { row: location[0], column: location[1] }
  end

  def update_mode
    @mode = :computer
  end

  def game_over?
    return false unless @previous_piece

    previous_color = @previous_piece.color == :white ? :black : :white
    no_legal_moves_captures?(previous_color)
  end

  def initial_placement
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
    @white_king = @data[7][4]
    @black_king = @data[0][4]
    update_all_moves_captures
  end

  # prints chess board using the displayable module
  def to_s
    print_chess_board
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

  def update_all_moves_captures
    pieces = @data.flatten(1).compact
    pieces.each { |piece| piece.update(self) }
  end

  def en_passant_capture?(coords)
    @previous_piece&.location == [coords[:row], coords[:column]] &&
      en_passant_pawn?
  end

  def pawn_promotion?(coords)
    @active_piece.symbol == " \u265F " && promotion_rank?(coords[:row])
  end

  def castling?(coords)
    file_difference = (coords[:column] - @active_piece.location[1]).abs
    @active_piece&.symbol == " \u265A " && file_difference == 2
  end

  def promotion_rank?(rank)
    color = @active_piece.color
    (color == :white && rank.zero?) || (color == :black && rank == 7)
  end

  def en_passant_pawn?
    two_pawns? && @active_piece.en_passant_rank? && @previous_piece.en_passant
  end

  def two_pawns?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F "
  end

  def castling_moves?
    location = @active_piece.location
    rank = location[0]
    file = location[1]
    king_side = [rank, file + 2]
    queen_side = [rank, file - 2]
    @active_piece&.moves&.include?(king_side) ||
      @active_piece&.moves&.include?(queen_side)
  end

  def no_legal_moves_captures?(color)
    pieces = @data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color == color

      piece.moves.size.positive? || piece.captures.size.positive?
    end
  end
end
