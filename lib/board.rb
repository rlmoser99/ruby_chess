# frozen_string_literal: true

require 'observer'
require_relative 'displayable.rb'

# contains logic for chess board
class Board
  include Displayable
  include Observable
  attr_reader :black_king, :white_king
  attr_accessor :data, :active_piece, :previous_piece

  def initialize(data = Array.new(8) { Array.new(8) }, active_piece = nil)
    @data = data
    @active_piece = active_piece
    @previous_piece = nil
    @black_king = nil
    @white_king = nil
    @movement = nil
  end

  # Tested (used in Game)
  def update_active_piece(coordinates)
    @active_piece = data[coordinates[:row]][coordinates[:column]]
  end

  # Tested (used in Game)
  def active_piece_moveable?
    @active_piece.moves.size >= 1 || @active_piece.captures.size >= 1
  end

  # Tested (used in Game)
  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @active_piece.moves.any?([row, column]) ||
      @active_piece.captures.any?([row, column])
  end

  # Tested (used in Game)
  def valid_piece?(coords, color)
    piece = @data[coords[:row]][coords[:column]]
    piece&.color == color
  end

  # Script Method -> No tests needed (test inside methods)
  # Tested (movement received update_pieces)
  def update(coords)
    @movement = update_movement(coords)
    @movement.update_pieces(self, coords)
    reset_board_values
  end

  # Tested
  def update_movement(coords)
    if en_passant_capture?(coords)
      EnPassantMovement.new
    elsif pawn_promotion?(coords)
      PawnPromotionMovement.new
    elsif castling?(coords)
      CastlingMovement.new
    else
      BasicMovement.new
    end
  end

  # Tested (used in Game)
  def possible_en_passant?
    @active_piece&.captures&.include?(@previous_piece&.location) &&
      en_passant_pawn?
  end

  # Tested (used in Game)
  def possible_castling?
    @active_piece.symbol == " \u265A " && castling_moves?
  end

  # Tested (used in Board & Game)
  def check?(color)
    king = color == :white ? @white_king : @black_king
    pieces = @data.flatten(1).compact
    pieces.any? do |piece|
      next unless piece.color != king.color

      piece.captures.include?(king.location)
    end
  end

  # Tested (used in Game)
  def game_over?
    return false unless @previous_piece

    color = @previous_piece.color == :white ? :black : :white
    return false unless check?(color)

    no_legal_moves_captures?(color)
  end

  # Tested (used in Board)
  def initial_placement
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
    @white_king = @data[7][4]
    @black_king = @data[0][4]
    update_all_moves_captures
  end

  # Only Puts Method -> No tests needed (used in Game)
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
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil
    changed
    notify_observers(self)
  end

  # Used at beginning of game to update all pieces moves/captures
  def update_all_moves_captures
    pieces = @data.flatten(1).compact
    pieces.each { |piece| piece.update(self) }
  end

  # Checks if there is a en_passant capture during board update.
  def en_passant_capture?(coords)
    @previous_piece&.location == [coords[:row], coords[:column]] &&
      en_passant_pawn?
  end

  # Checks if there is a castling moves during board update.
  def castling?(coords)
    file_difference = (coords[:column] - @active_piece.location[1]).abs
    @active_piece&.symbol == " \u265A " && file_difference == 2
  end

  # Tested - Checks if there is a pawn promotion moves during board update.
  def pawn_promotion?(coords)
    @active_piece.symbol == " \u265F " && promotion_rank?(coords[:row])
  end

  # Used in board -> determines strategy
  # Tested inside pawn_promotion?
  def promotion_rank?(rank)
    color = @active_piece.color
    (color == :white && rank.zero?) || (color == :black && rank == 7)
  end

  # Used in board -> for game#warning & determines strategy
  # Checks if previous & active pieces are pawns, and if previous is en passant.
  def en_passant_pawn?
    two_pawns? && @active_piece.en_passant_rank? && @previous_piece.en_passant
  end

  # Used in board -> for game#warning & determines strategy
  # Checks is both pieces are pawns
  def two_pawns?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F "
  end

  # Used in board -> for game#warning
  # Determines if active piece's moves include castling locations.
  def castling_moves?
    location = @active_piece.location
    rank = location[0]
    file = location[1]
    king_side = [rank, file + 2]
    queen_side = [rank, file - 2]
    @active_piece&.moves&.include?(king_side) ||
      @active_piece&.moves&.include?(queen_side)
  end

  # Used in board -> for game_over?
  # Determines if there is no more legal moves or captures
  def no_legal_moves_captures?(color)
    pieces = @data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color == color

      piece.moves.size.positive? || piece.captures.size.positive?
    end
  end
end
