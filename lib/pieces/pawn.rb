# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Pawn < Piece
  attr_reader :color, :symbol, :location, :en_passant, :moves, :captures

  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = " \u265F "
    @moved = false
    @en_passant = false
    @moves = []
    @captures = []
  end

  def update_location(row, column)
    update_en_passant(row)
    @location = [row, column]
    @moved = true
  end

  # Tested
  # Can refactor!
  def current_moves(board)
    possibilities = find_valid_moves(board)
    @moves = remove_king_check_moves(board, possibilities)
  end

  def find_valid_moves(board)
    possibilities = []
    rank = @location[0] + rank_direction
    file = @location[1]
    possibilities << [rank, file] unless board.data[rank][file]
    bonus = first_move_bonus
    possibilities << bonus unless @moved || board.data[bonus[0]][bonus[1]]
    possibilities
  end

  # Tested
  # Can refactor!
  def current_captures(board)
    possibilities = format_valid_captures(board)
    @captures = remove_king_check_moves(board, possibilities)
  end

  def format_valid_captures(board)
    previous_location = board.previous_piece.location if board.previous_piece
    captures = []
    rank = @location[0] + rank_direction
    file = @location[1]
    lower_file = file - 1
    higher_file = file + 1
    if opposing_piece?(rank, lower_file, board.data)
      captures << [rank, lower_file]
    end
    if opposing_piece?(rank, higher_file, board.data)
      captures << [rank, higher_file]
    end
    captures << previous_location if valid_en_passant?(board.previous_piece)
    captures
  end

  # White can only move up and Black can only move down
  def rank_direction
    color == :white ? -1 : 1
  end

  # Tested in current_captures
  # NOW PUBLIC, due to use in board -> MAKE TESTS!!!
  # Checks if black pawn is in 4th row or white pawn is in 3rd row
  def en_passant_rank?
    (location[0] == 4 && color == :black) || (location[0] == 3 && color == :white)
  end

  private

  # Tested in update_location
  # Changes en_passant value depending on if last move was two spaces (true) or not.
  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  def first_move_bonus
    double_rank = @location[0] + (rank_direction * 2)
    file = @location[1]
    [double_rank, file]
  end

  # Tested in current_captures
  # Checks that a piece is a pawn & that en_passant rank is valid
  def valid_en_passant?(piece)
    en_passant_rank? && symbol == piece.symbol && piece.en_passant
  end
end
