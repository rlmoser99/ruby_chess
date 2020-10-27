# frozen_string_literal: true

require 'observer'
require_relative 'displayable.rb'

# contains logic for chess board
class Board
  include Displayable
  include Observable
  attr_reader :black_king, :white_king, :mode
  attr_accessor :data, :active_piece, :previous_piece

  def initialize(data = Array.new(8) { Array.new(8) }, active_piece = nil)
    @data = data
    @active_piece = active_piece
    @previous_piece = nil
    @black_king = nil
    @white_king = nil
    @mode = :user_prompts
  end

  # updates the board's active piece to use during a player's turn
  def update_active_piece(coordinates)
    @active_piece = data[coordinates[:row]][coordinates[:column]]
  end

  # returns true if active piece has legal moves or captures
  def active_piece_moveable?
    @active_piece.moves.size >= 1 || @active_piece.captures.size >= 1
  end

  # returns true if coords are one of the active piece's legal moves or captures
  def valid_piece_movement?(coords)
    row = coords[:row]
    column = coords[:column]
    @active_piece.moves.any?([row, column]) ||
      @active_piece.captures.any?([row, column])
  end

  # returns true if coords are a piece of the specified color
  def valid_piece?(coords, color)
    piece = @data[coords[:row]][coords[:column]]
    piece&.color == color
  end

  # script to update the pieces based on movement strategy & reset for next turn
  def update(coords)
    movement = create_movement(coords)
    movement.update_pieces(self, coords)
    reset_board_values
  end

  # returns true if active piece can capture the previous piece en passant
  def possible_en_passant?
    @active_piece&.captures&.include?(@previous_piece&.location) &&
      en_passant_pawn?
  end

  # returns true if active piece is a king and can castle with their rook
  def possible_castling?
    @active_piece.symbol == " \u265A " && castling_moves?
  end

  # returns true if specified color king can be captured
  def king_in_check?(color)
    king = color == :white ? @white_king : @black_king
    pieces = @data.flatten(1).compact
    pieces.any? do |piece|
      next unless piece.color != king.color

      piece.captures.include?(king.location)
    end
  end

  # returns the coordinates of a black piece that has legal moves/captures
  def random_black_piece
    pieces = @data.flatten(1).compact
    black_pieces = pieces.select do |piece|
      next unless piece.color == :black

      piece.moves.size.positive? || piece.captures.size.positive?
    end
    location = black_pieces.sample.location
    { row: location[0], column: location[1] }
  end

  # returns the coordinates of a legal move/capture of the active piece
  def random_black_move
    possibilities = @active_piece.moves + @active_piece.captures
    location = possibilities.sample
    { row: location[0], column: location[1] }
  end

  # changes the mode to :computer to enable computer player turns
  def update_mode
    @mode = :computer
  end

  # returns true when there are no legal moves or captures for previous color
  def game_over?
    return false unless @previous_piece

    previous_color = @previous_piece.color == :white ? :black : :white
    no_legal_moves_captures?(previous_color)
  end

  # script to create and update pieces for a new game
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

  # creates eight pawns for the specified color and row number
  def initial_pawn_row(color, number)
    8.times do |index|
      @data[number][index] =
        Pawn.new(self, { color: color, location: [number, index] })
    end
  end

  # creates eight pieces for the specified color and row number
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

  # updates moves/captures for all pieces (used at the beginning of game)
  def update_all_moves_captures
    pieces = @data.flatten(1).compact
    pieces.each { |piece| piece.update(self) }
  end

  # creates movement strategy based on the coordinates of the move
  def create_movement(coords)
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

  # returns true when coords are a pawn captured en_passant
  def en_passant_capture?(coords)
    @previous_piece&.location == [coords[:row], coords[:column]] &&
      en_passant_pawn?
  end

  # returns true when active piece is a pawn & coords are its promotion rank
  def pawn_promotion?(coords)
    @active_piece.symbol == " \u265F " && promotion_rank?(coords[:row])
  end

  # returns true when active piece is a king & coords column is 2 files away
  def castling?(coords)
    file_difference = (coords[:column] - @active_piece.location[1]).abs
    @active_piece&.symbol == " \u265A " && file_difference == 2
  end

  # script to reset for next turn and notify pieces to update moves/captures
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil
    changed
    notify_observers(self)
  end

  # returns true if color of active piece matches the cooresponding rank
  def promotion_rank?(rank)
    color = @active_piece.color
    (color == :white && rank.zero?) || (color == :black && rank == 7)
  end

  # returns true if active is pawn in rank & previous is a pawn with en passant
  def en_passant_pawn?
    two_pawns? && @active_piece.en_passant_rank? && @previous_piece.en_passant
  end

  # returns true if previous piece and active piece are both pawns
  def two_pawns?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F "
  end

  # returns true if active piece's moves include king-side or queen-side move
  def castling_moves?
    location = @active_piece.location
    rank = location[0]
    file = location[1]
    king_side = [rank, file + 2]
    queen_side = [rank, file - 2]
    @active_piece&.moves&.include?(king_side) ||
      @active_piece&.moves&.include?(queen_side)
  end

  # returns true if pieces of specified color have no legal moves/captures
  def no_legal_moves_captures?(color)
    pieces = @data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color == color

      piece.moves.size.positive? || piece.captures.size.positive?
    end
  end
end
